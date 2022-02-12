//
//  ApiMoya.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 11/02/22.
//


import Foundation
import Moya

enum BlogPostMoyaTarget {
    case getPosts
    case showPost(id: Int)
    case createPost(param: NewPostParam)
    case updatePost(id: Int, param: NewPostParam)
    case deletePost(id: Int)
    
    
}

extension BlogPostMoyaTarget: TargetType {

    var baseURL: URL {
        
        return URL(string: "https://limitless-forest-49003.herokuapp.com")!
    }

    var useMockServer: Bool {
        return false
    }
    
    var headers: [String: String]? {
        return [:]
    }

    var path: String {

        switch self {
        case .getPosts:
            return "/posts"
        case .showPost(let param):
            return "/posts/\(param)"
        case .createPost(_):
            return "/posts"
        case .updatePost(let param, _):
            return "/posts/\(param)"
        case .deletePost(let param):
            return "/posts/\(param)"

        
        }
    }

    var method: Moya.Method {
        switch self {
        case .getPosts:
            return .get
        case .showPost:
            return .get
        case .createPost:
            return .post
        case .updatePost:
            return .put
        case .deletePost:
            return .delete

        
        }
    }

    var parameterEncoding: ParameterEncoding {
        
        return URLEncoding.default
    }

    var parameters: [String: Any] {

        
        switch self {
        case .createPost(let param), .updatePost(_, let param):
            return [
                "title": param.title,
                "content": param.content
            ]
        default:
            return [:]
        }
        
    }

    var task: Task {
        return .requestParameters(parameters: parameters, encoding: parameterEncoding)
    }

    var sampleData: Data {
        return Data()
    }
}
