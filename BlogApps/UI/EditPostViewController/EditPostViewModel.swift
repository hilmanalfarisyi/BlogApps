//
//  ShowFullPostViewModel.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 13/02/22.
//

import Foundation
import RxSwift

class EditPostViewModel {
    
    private var navigationTitle = PublishSubject<String>()
    private var title = PublishSubject<String>()
    private var content = PublishSubject<String>()
    private var showLoading = PublishSubject<Bool>()
    private var backToListPostScreen = PublishSubject<Void>()
    private var error = PublishSubject<String>()
    
    var errorObservable : Observable<String> {
        error.asObservable()
    }
    
    var titleObservable : Observable<String> {
        title.asObservable()
    }
    
    var navigationTitleObservable : Observable<String> {
        navigationTitle.asObservable()
    }
    
    var backToListScreenObservable : Observable<Void> {
        backToListPostScreen.asObservable()
    }
    
    var contentObservable : Observable<String> {
        content.asObservable()
    }
    
    var showLoadingObservable : Observable<Bool> {
        showLoading.asObservable()
    }
    
    var networkModel = BlogPostDefaultNetworkModel()
    var dispose  = DisposeBag()
    let post : Post?
    
    init(post: Post?) {
        
        self.post = post
       
    }
    
    func viewDidAppear() {
        
        if post != nil {
            navigationTitle.onNext("Edit Post")
        } else {
            navigationTitle.onNext("Create Post")
        }
        
        title.onNext(post?.title ?? "")
        content.onNext(post?.content ?? "")
    }
    
    
    func submitNewPost(param :NewPostParam) {
        
        showLoading.onNext(true)
        
        if post != nil {
            networkModel.updateBlogPost(id: post!.id, param: param  )
                .subscribe { [weak self] (post : Post) in
                    self?.showLoading.onNext(false)
                    self?.backToListPostScreen.onNext(())
                         
            
            } onError: { [weak self](error: Error) in
                self?.showLoading.onNext(false)
                self?.error.onNext("Something Wrong, Please Try Again")
            
            
            } .disposed(by: dispose)

        } else {
            networkModel.createBlogPost(param: param)
                .subscribe {[weak self] (post : Post) in
                    self?.showLoading.onNext(false)
                    self?.backToListPostScreen.onNext(())
                     
                    
                } onError: { [weak self] (error: Error) in
                    self?.showLoading.onNext(false)
                    self?.error.onNext("Something Wrong, Please Try Again")
                } .disposed(by: dispose)
        }
        
                
                

                
      
    }
    
    
    
    
}
