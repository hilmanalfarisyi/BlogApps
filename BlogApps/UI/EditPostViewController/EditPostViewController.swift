//
//  EditPostViewController.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 13/02/22.
//

import UIKit
import RxSwift
import SVProgressHUD

class EditPostViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentVIew: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    
    var dispose = DisposeBag()
    var viewModel: EditPostViewModel?
    
    convenience init(viewModel: EditPostViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.viewDidAppear()
    }
    
    private func configureView() {
        
        
        titleView.backgroundColor = .blue
        titleView.roundCorners(corners: [.allCorners], radius: 5)
        
        contentVIew.backgroundColor = .blue
        contentVIew.roundCorners(corners: [.allCorners], radius: 5)
        self.navigationItem.backButtonTitle = " "
//        self.navigationItem.hidesBackButton = true
         
        
    }

    
    private func bindViewModel() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        
        bindTitle(viewModel: viewModel)
        bindContent(viewModel: viewModel)
        bindLoadingView(viewModel: viewModel)
        bindBackToListScreen(viewModel: viewModel)
        bindNavigationTitle(viewModel: viewModel)
    }
    
    private func bindLoadingView(viewModel : EditPostViewModel) {
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
    
    private func bindTitle(viewModel : EditPostViewModel) {
        viewModel.titleObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (title: String) in
              
                self?.titleTextView.text = title
              
            }.disposed(by: dispose)

    }
    
    private func bindNavigationTitle(viewModel : EditPostViewModel) {
        viewModel.navigationTitleObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (title: String) in
              
                self?.title = title
                
                

              
            }.disposed(by: dispose)

    }
    
    private func bindBackToListScreen(viewModel : EditPostViewModel) {
        viewModel.backToListScreenObservable
            .delay(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (_) in
              
                self?.navigationController?.popViewController(animated: true)
              
            }.disposed(by: dispose)

    }
    
    private func bindContent(viewModel : EditPostViewModel) {
        viewModel.contentObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (content: String) in
              
                self?.contentTextView.text = content
              
            }.disposed(by: dispose)

    }

    @IBAction func onSubmitButtonTapped(_ sender: Any) {
        viewModel?.submitNewPost(param: NewPostParam(title: titleTextView.text, content: contentTextView.text))
        
    }
    

}
