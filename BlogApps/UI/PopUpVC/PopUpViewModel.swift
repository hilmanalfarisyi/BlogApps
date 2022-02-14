//
//  PopUpViewModel.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 12/02/22.
//

import Foundation
import RxSwift


class PopUpViewModel {

    let post : Post
    
    var networkModel = BlogPostDefaultNetworkModel()
    var dispose  = DisposeBag()
    
    private var dismissView = PublishSubject<Void>()
    private var showLoading = PublishSubject<Bool>()
    private var title = PublishSubject<String>()
    
    var showLoadingObservable : Observable<Bool> {
        showLoading.asObservable()
    }
    
    var titlebservable : Observable<String> {
        title.asObservable()
    }
    
    var dismissViewObservable : Observable<Void> {
        dismissView.asObservable()
    }
    
    init(post: Post) {
        
        self.post = post
    }
    
    func viewDidAppear() {
        
        title.onNext("Are you sure to delete post with title '\(post.title)' ?")
    }
    
    func onDeletePost() {
        
        showLoading.onNext(true)
        networkModel.deleteBlogPost(id: post.id)
            .subscribe {[weak self] (post : Post) in
                self?.showLoading.onNext(false)
                self?.dismissView.onNext(())
                
                let postData:[String: Post] = ["post": post]
                NotificationCenter.default.post(name: Notification.Name("deletePost"), object: nil, userInfo: postData)
                
            
            
        } onError: { [weak self] (error: Error) in
            self?.showLoading.onNext(false)
          
        }.disposed(by: dispose)
        
    }
    
    
}

