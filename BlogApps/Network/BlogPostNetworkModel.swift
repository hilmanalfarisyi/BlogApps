//
//  BlogPostNetworkModel.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 11/02/22.
//

import Foundation
import RxSwift

protocol BlogPostNetworkModel {
    
    
    func retrieveListBlogPost() -> Observable<[Post]>
    func showBlogPost(id: Int) -> Observable<Post>
    func createBlogPost(param: NewPostParam) -> Observable<Post>
    func deleteBlogPost(id: Int) -> Observable<Post>
    func updateBlogPost(id: Int, param: NewPostParam) -> Observable<Post>
    
}
