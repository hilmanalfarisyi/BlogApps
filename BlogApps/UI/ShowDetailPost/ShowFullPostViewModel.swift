//
//  ShowFullPostViewModel.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 13/02/22.
//

import Foundation
import RxSwift

class ShowFullPostViewModel {
    
    
    
    private var title = PublishSubject<String>()
    private var content = PublishSubject<String>()
    private var showLoading = PublishSubject<Bool>()
    
    var showLoadingObservable : Observable<Bool> {
        showLoading.asObservable()
    }
    var titleObservable : Observable<String> {
        title.asObservable()
    }
    
    var contentObservable : Observable<String> {
        content.asObservable()
    }
    
    var dispose  = DisposeBag()
    var networkModel = BlogPostDefaultNetworkModel()
    private var post : Post
    
    init(post: Post) {
        
        self.post = post
        
    }
    
    func viewDideAppear() {
        
        getDetailPost()
        
    }
    
    func getPost() -> Post {
    
        post
    
    }
    
    func getDetailPost() {
        
        showLoading.onNext(true)
        networkModel.showBlogPost(id: post.id)
            .subscribe { [weak self] (post : Post) in
                
                self?.post = post
                self?.title.onNext(post.title)
                self?.content.onNext(post.content)
                self?.showLoading.onNext(false)
                
            } onError: { [weak self] (error: Error) in
                self?.showLoading.onNext(false)
                

            }.disposed(by: dispose)
        
    }
    
    
}
