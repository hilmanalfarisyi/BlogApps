//
//  ShowFullPostViewController.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 13/02/22.
//

import UIKit
import RxSwift
import SVProgressHUD

class ShowFullPostViewController: UIViewController {
    
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var contentView: UIView!
    
    var dispose = DisposeBag()
    var viewModel: ShowFullPostViewModel?
    
    lazy var blurredView: UIView = {
           
           let containerView = UIView()
           
           let blurEffect = UIBlurEffect(style: .light)
           let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
           customBlurEffectView.frame = self.view.bounds
           
           let dimmedView = UIView()
           dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
           dimmedView.frame = self.view.bounds
           
           
           containerView.addSubview(customBlurEffectView)
           containerView.addSubview(dimmedView)
           return containerView
       }()
    
    convenience init(viewModel: ShowFullPostViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bindViewModel()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.viewDideAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    private func configureView() {
        
        view.addSubview(blurredView)
        view.sendSubviewToBack(blurredView)
        
        DispatchQueue.main.async { [weak self] in
            self?.contentView.roundCorners(corners: [.topRight, .topLeft], radius: 15)
            
        }
        
    }
    
    private func bindViewModel() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        bindTitle(viewModel: viewModel)
        bindContent(viewModel: viewModel)
        bindLoadingView(viewModel: viewModel)
      
        bindErrorRequest(viewModel: viewModel)
    }
    
    private func bindErrorRequest(viewModel : ShowFullPostViewModel) {
        viewModel.errorObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (errorMessage: String) in
                
                self?.showError(content: errorMessage)
           
            }.disposed(by: dispose)

    }
    
    private func bindLoadingView(viewModel : ShowFullPostViewModel) {
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
    
    private func bindTitle(viewModel : ShowFullPostViewModel) {
        viewModel.titleObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (title: String) in
              
                self?.titleLable.text = title
              
            }.disposed(by: dispose)

    }
    
    private func bindContent(viewModel : ShowFullPostViewModel) {
        viewModel.contentObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (content: String) in
              
                self?.contentLabel.text = content
              
            }.disposed(by: dispose)

    }
    
    private func editPost(post: Post) {
        
        
        let editPostVc = EditPostViewController(viewModel: EditPostViewModel(post: post))
        self.navigationController?.pushViewController(editPostVc, animated: true)
        
    }
    
    private func showError(content: String) {
        
        let alert = UIAlertController(title: "Alert", message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { [weak self] action in
            self?.viewModel?.getDetailPost()
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
  
    @IBAction func onCloseButtonTapped(_ sender: Any) {
        
        SVProgressHUD.dismiss()
        self.dismiss(animated: true) {
            
        }
        
    }
    
    @IBAction func onDeleteButtonTapped(_ sender: Any) {
        
        guard let viewModel = viewModel else {
            return
        }
        
        
        self.dismiss(animated: true) {
            
            let postData:[String: Post] = ["post": viewModel.getPost()]
            NotificationCenter.default.post(name: Notification.Name("showDeletePostVC"), object: nil, userInfo: postData)
        }
        
    }
    
    @IBAction func onEditButtonTapped(_ sender: Any) {
        
        
        guard let viewModel = viewModel else {
            return
        }
        
        
        self.dismiss(animated: true) {
            
            let postData:[String: Post] = ["post": viewModel.getPost()]
            NotificationCenter.default.post(name: Notification.Name("showEditPostVC"), object: nil, userInfo: postData)
        }
        
        
    }
    
}
