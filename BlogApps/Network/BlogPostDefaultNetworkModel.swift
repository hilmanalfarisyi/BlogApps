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
        
        return provider.rx.request(.getPosts).filterSuccessfulStatusCodes().map([Post].self).asObservable()
    }
    
    func showBlogPost(id: Int) -> Observable<Post> {
        
        return provider.rx.request(.showPost(id: id)).filterSuccessfulStatusCodes().map(Post.self).asObservable()
    }
    
    func createBlogPost(param: NewPostParam) -> Observable<Post> {
        
        return provider.rx.request(.createPost(param: param)).filterSuccessfulStatusCodes().map(Post.self).asObservable()

    }
    
    func deleteBlogPost(id: Int) -> Observable<Post> {
        
        return provider.rx.request(.deletePost(id: id)).filterSuccessfulStatusCodes().map(Post.self).asObservable()

    }
    
    func updateBlogPost(id: Int, param: NewPostParam) -> Observable<Post> {
        
        return provider.rx.request(.updatePost(id: id, param: param)).filterSuccessfulStatusCodes().map(Post.self).asObservable()

    }
    
    
    
    
}
