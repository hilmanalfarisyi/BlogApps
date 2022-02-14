//
//  ListPostViewController.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 11/02/22.
//

import UIKit
import SVProgressHUD
import RxSwift


class ListPostViewController: UIViewController {

    @IBOutlet private weak var listPostTableView: UITableView!
    @IBOutlet private weak var addNewPostImageView: UIImageView!
    
    var dispose  = DisposeBag()
    var viewModel: ListPostViewModel?
    
    convenience init(viewModel: ListPostViewModel) {
        self.init()
        self.viewModel = viewModel
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        bindViewModel()
        addDeleteListener()
        
    }
    
    private func configureView() {
        
        self.title = "Blog Post"
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCreatePostVC(tapGestureRecognizer:)))
        addNewPostImageView.isUserInteractionEnabled = true
        addNewPostImageView.addGestureRecognizer(tapGestureRecognizer)
        
        configureTableView()
    }
    
    
    
    private func configureTableView() {
        
        let nib = UINib(nibName: "BlogPostTableViewCell", bundle: nil)
        listPostTableView.register(nib, forCellReuseIdentifier: "BlogPostTableViewCell")
        listPostTableView.delegate = self
        listPostTableView.dataSource = self
        
    }
    
    private func bindViewModel() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        
        bindLoadingView(viewModel: viewModel)
        bindReloadTableView(viewModel: viewModel)
        bindDeletePost(viewModel: viewModel)
    }
    
    private func bindLoadingView(viewModel : ListPostViewModel) {
        viewModel.showLoadingObservable
            .observe(on: MainScheduler.instance)
            .subscribe { (isShowLoading: Bool) in
                
                if isShowLoading {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            }.disposed(by: dispose)

    }
    
    private func bindReloadTableView(viewModel: ListPostViewModel) {
        
        viewModel.reloadTableViewObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (_) in
                
                self?.listPostTableView.reloadData()
                
            }.disposed(by: dispose)
    }
    
    private func bindDeletePost(viewModel: ListPostViewModel) {
        
        viewModel.deletePostObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (post: Post) in
                
                self?.deletePost(post: post)
                
            }.disposed(by: dispose)
    }
    
    private func reloadData() {
        listPostTableView.reloadData()
    }
   
    @objc func showCreatePostVC(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let editPostVc = EditPostViewController(viewModel: EditPostViewModel(post: nil))
        
        self.navigationController?.pushViewController(editPostVc, animated: true)

        // Your action
    }
    
    
    
  
    private func editPost(post: Post) {
        
        let editPostVc = EditPostViewController(viewModel: EditPostViewModel(post: post))
        self.navigationController?.pushViewController(editPostVc, animated: true)
        
    }
    
    private func deletePost(post: Post) {
        
        let popUpViewModel = PopUpViewModel(post: post)
        let PopUpVC = PopUpViewController(viewModel : popUpViewModel)
        PopUpVC.modalPresentationStyle = .overCurrentContext
        self.present(PopUpVC, animated: true)
        
    }
    
    private func showFullPost(post: Post) {
        
        let fullPostViewModel = ShowFullPostViewModel(post: post)
        let fullPostVc = ShowFullPostViewController(viewModel : fullPostViewModel)
        fullPostVc.modalPresentationStyle = .overCurrentContext
        self.present(fullPostVc, animated: true)
        
    }
    
    private func addDeleteListener() {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(deletePostListener), name: NSNotification.Name("deletePost"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showEditPostVC), name: NSNotification.Name("showEditPostVC"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDeletePostVc), name: NSNotification.Name("showDeletePostVC"), object: nil)
        
        
    }
    
    
    @objc func deletePostListener(_ notification: NSNotification) {
        
        if let data = notification.userInfo?["post"] as? Post {
           
            viewModel?.onDeleteSuccess(post: data)
         }
        
        
    }
    
    
    @objc func showEditPostVC(_ notification: NSNotification) {
        
        if let data = notification.userInfo?["post"] as? Post {
            
            editPost(post: data)
         }
        
        
    }
    
    @objc func showDeletePostVc(_ notification: NSNotification) {
        
        if let data = notification.userInfo?["post"] as? Post {
            
            deletePost(post: data)
         }
        
        
    }
    

}

extension ListPostViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return viewModel?.getListPostCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogPostTableViewCell", for: indexPath) as! BlogPostTableViewCell

        guard let viewModel  = viewModel else {
            return cell
        }
        
        cell.bindView(post: viewModel.getListPostItem(index: indexPath.row))
        cell.onDeleteButtonTapped =  { [weak self] (post: Post) in
            
            self?.viewModel?.onDeletePost(post: post)
        }
        
        cell.onEditButtonTapped =  { [weak self] (post: Post) in
            
            self?.editPost(post: post)
        }
        
        cell.selectionStyle = .none
        
        return cell
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
    
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) { [weak self] in
            self?.addNewPostImageView.isHidden = true
            
            
            
            self?.view.layoutIfNeeded()
        }
    }
    
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) { [weak self] in
            self?.addNewPostImageView.isHidden = false
            
            self?.view.layoutIfNeeded()
        }
        
    }
    
    
    
    
}

extension ListPostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let viewModel  = viewModel else {
            return
        }
        
        showFullPost(post: viewModel.getListPostItem(index: indexPath.row))
        
    }
    
}

