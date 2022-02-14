//
//  ListPostViewModel.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 12/02/22.
//

import Foundation
import RxSwift
import RxCocoa

class ListPostViewModel {
    
    
    
    var listPost = [Post]()
    
    var networkModel = BlogPostDefaultNetworkModel()
    var dispose  = DisposeBag()
    
    private var showLoading = BehaviorRelay<Bool>(value: false)
    private var reloadTableView = PublishSubject<Void>()
    
    private var deletePost = PublishSubject<Post>()
    
    
    var showLoadingObservable : Observable<Bool> {
        showLoading.asObservable()
    }
    
    var reloadTableViewObservable : Observable<Void> {
        reloadTableView.asObservable()
    }
    
    var deletePostObservable : Observable<Post> {
        deletePost.asObservable()
    }
    
    
    init() {
        retriveListBlogPost()
    }
    
    func retriveListBlogPost() {
        
        showLoading.accept(true)
        networkModel.retrieveListBlogPost().subscribe { [weak self] (listpost : [Post]) in
            
            self?.listPost = listpost
            self?.showLoading.accept(false)
            self?.reloadTableView.onNext(())
            
            
            print("DebugRequest retriveListBlogPost \(listpost)")
            
            
        } onError: { [weak self] (error: Error) in
            self?.showLoading.accept(false)
            print("DebugRequest retriveListBlogPost error \(error)")
            

        }.disposed(by: dispose)
 
    }
    
    func getListPostCount() -> Int {
        listPost.count
    }
    
    func getListPostItem(index: Int) -> Post {
        return listPost[index]
        
    }
    
    func onDeletePost(post: Post) {
        deletePost.onNext(post)
    }
    
    func onDeleteSuccess(post: Post) {
        
        for (index, item) in listPost.enumerated() {
            
            
            if item.id == post.id {
            
                listPost.remove(at: index)
                break
            }
        }
        
        reloadTableView.onNext(())
    }
    
    
    
    
}
