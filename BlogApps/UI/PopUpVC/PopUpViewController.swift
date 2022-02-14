//
//  PopUpViewController.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 12/02/22.
//

import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD


class PopUpViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    var dispose = DisposeBag()
    var viewModel: PopUpViewModel?
    
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
    
    convenience init(viewModel: PopUpViewModel) {
        self.init()
        
        self.viewModel = viewModel
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindViewModel()
        self.view.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
        
        yesButton.addTarget(self, action: #selector(onYesButtonTapped), for: UIControl.Event.touchUpInside)
        noButton.addTarget(self, action: #selector(onNoButtonTapped), for: UIControl.Event.touchUpInside)
    }
    
    private func configureView() {
        
        view.addSubview(blurredView)
        view.sendSubviewToBack(blurredView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.viewDidAppear()
    }
    
    private func bindViewModel() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        bindShowLoading(viewModel: viewModel)
        bindDismissView(viewModel: viewModel)
        bindTitle(viewModel: viewModel)
    }
    
    private func bindShowLoading(viewModel: PopUpViewModel) {
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
    
    private func bindDismissView(viewModel: PopUpViewModel) {
        viewModel.dismissViewObservable
            .delay(RxTimeInterval.milliseconds(200), scheduler: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] (_) in
                
                self?.dismiss(animated: true, completion: {
                    
                })
                
            }.disposed(by: dispose)

        
    }
    
    private func bindTitle(viewModel: PopUpViewModel) {
        viewModel.titlebservable
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] (title: String) in
                
                self?.titleLabel.text = title
                
            }.disposed(by: dispose)

    }
    
    @objc func onYesButtonTapped() {
        self.viewModel?.onDeletePost()
        
    }
    
    @objc func onNoButtonTapped() {
        self.dismiss(animated: true)
    }

  

}
