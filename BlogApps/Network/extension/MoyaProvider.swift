//
//  MoyaProvider.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 11/02/22.
//


import Moya
import RxSwift
import netfox

extension MoyaProvider {
    
    public static func defaultProvider() -> MoyaProvider {
        return MoyaProvider(session: RequestManager.sharedInstance(), plugins: defaultPlugins())
    }

    static private func defaultPlugins() -> [PluginType] {

      return [  NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
    }
}


extension MoyaProvider {
    
    // MARK: - Public methods
    
    /**
    Replacements for standard `RxMoya` `request` method, which has the ability to catch the error response from server. sends `next` event when succeeds, and otherwise will sends `error` event with predefined error information from the server.
    
    - parameters:
        - target: Moya `TargetType`
    
    - returns: `Observable<Response>`
    */
    public func requestWithValidation(_ target: Target) -> Observable<Response> {
        
        return self.rx.request(target)
            .asObservable()
            .catch { _ -> Observable<Response> in
                
                return Observable<Response>.error(NetworkError.unknown)
            }
            .flatMap({ (response: Response) -> Observable<Response> in
                
                let responseSuccess: CountableRange<Int> = (200..<300)
                
                
                switch response.statusCode {
                    
                case responseSuccess:
                    return Observable<Response>.just(response)
                    
                default:
                    
                    guard let JSON = try? response.mapJSON(),
                          let _ = JSON as? [String: Any] else {
                            return Observable<Response>.error(NetworkError.unknown)
                    }
                    
                    return Observable<Response>.error(NetworkError.unknown)
                    
                }
                
            })
    }
    
}
