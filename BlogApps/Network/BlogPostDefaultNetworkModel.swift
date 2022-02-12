//
//  BlogPostDefaultNetworkModel.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 11/02/22.
//

import Foundation
import Moya
import RxSwift

final class BlogPostDefaultNetworkModel: BlogPostNetworkModel {
    
    private let provider: MoyaProvider<BlogPostMoyaTarget>
    
    
    init(provider: MoyaProvider<BlogPostMoyaTarget> = .defaultProvider()) {
        self.provider = provider
    }

    
    func retrieveListBlogPost() -> Observable<[Post]> {
        print("DebugRequest retrieveListBlogPost")
        return provider.rx.request(.getPosts).filterSuccessfulStatusCodes().map([Post].self).asObservable()
//        return provider.requestWithValidation(.getPosts)
//            .map(to: [Post].self)
//            .flatMapForServerResponse()
    }
    
    func showBlogPost() -> Observable<Post> {
        return provider.rx.request(.showPost(id: 2)).filterSuccessfulStatusCodes().map(Post.self).asObservable()
//        return provider.requestWithValidation(.showPost(id: 1))
//            .map(to: Post.self)
//            .flatMapForServerResponse()
        
//        return Observable.just(Post(id: 1, title: "title", content: "Content", publishedAt: "publishedAt", createdAt: "createdAt", updatedAt: "updatedAt"))
    }
    
    func createBlogPost(param: NewPostParam) -> Observable<Post> {
        return provider.rx.request(.createPost(param: param)).filterSuccessfulStatusCodes().map(Post.self).asObservable()
//        return Observable.just(false)
    }
    
    func deleteBlogPost(id: Int) -> Observable<Post> {
        
        return provider.rx.request(.deletePost(id: id)).filterSuccessfulStatusCodes().map(Post.self).asObservable()
//        return Observable.just(false)
    }
    
    func updateBlogPost(id: Int, param: NewPostParam) -> Observable<Post> {
        return provider.rx.request(.updatePost(id: id, param: param)).filterSuccessfulStatusCodes().map(Post.self).asObservable()
//        return Observable.just(false)
    }
    
    
    
    
}
