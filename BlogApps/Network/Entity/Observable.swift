////
////  Observable.swift
////  BlogApps
////
////  Created by lalu hilman  alfarisyi on 12/02/22.
////
//
//import Foundation
//import RxSwift
//import Moya
//import ObjectMapper
//
//
//extension Observable where Element: Any {
//    
//    /// Maps the sent `Element` to `Void`. Useful if you only need the `next` event.
//    public func mapToVoid() -> Observable<Void> {
//        
//        return self.map({ _ -> Void in
//            return
//        })
//    }
//}
//
//extension Observable where Element: OptionalType {
//
//    /**
//    Returns wrapped value through `next` event if the value is valid, and `error` event with parsing-related `NSError` if it's a `nil`.
//    */
//    public func flatMapForServerResponse() -> Observable<Element.Wrapped> {
//        
//        print("DebugRequest flatMapForServerResponse ")
//        return self.flatMap { (value: Element) -> Observable<Element.Wrapped> in
//            
//            if let validValue = value.optionalValue {
//                return Observable<Element.Wrapped>.just(validValue)
//            }
//        
//            print("DebugRequest return NetworkError.unknown ")
//            return Observable<Element.Wrapped>.error(NetworkError.unknown)
//        }
//    }
//}
//
//extension Observable where Element: Moya.Response {
//    
//    /**
//    Sends `next` event if there's a valid value in passed `keyPath`, and `error` event if it's a `nil`.
//    
//    - note: The default value for keyPath is `data`.
//    */
//    public func flatMapResponseToVoid(keyPath: String? = nil) -> Observable<Void> {
//        
//        return self.map({ (response: Element) -> Any? in
//            
//            guard let JSON = try? response.mapJSON(),
//                let validJSON = JSON as? [String: Any] else {
//                    
//                    return nil
//            }
//            
//            guard let validKeyPath = keyPath else {
//                return validJSON
//            }
//            
//            return validJSON[validKeyPath]
//        })
//        .flatMap({ (response: Any?) -> Observable<Void> in
//                
//            if response != nil {
//                return Observable<Void>.just(())
//            }
//            
//            return Observable<Void>.error(NetworkError.unknown)
//        })
//    }
//    
//    /**
//    Returns the passed Mappable-compliant object if mapping succeeds and `nil` if fails. Uses passed `keyPath` as root JSON source path.
//    
//    - note: The default keyPath is "data". Setting this to `nil` will make it take the whole response.
//    */
//    public func mapResponse<T: Mappable>(to type: T.Type, keyPath: String? = nil) -> Observable<T?> {
//        
//        return self.map { (response: Response) -> T? in
//            
//            guard let JSON = try? response.mapJSON(),
//                let validJSON = JSON as? [String: Any] else {
//                    return nil
//            }
//            
//            guard let validPath = keyPath else {
//                return Mapper<T>().map(JSON: validJSON)
//            }
//            
//            if let rawData = validJSON[validPath] as? [String: Any] {
//                
//                return Mapper<T>().map(JSON: rawData)
//                
//            } else {
//                
//                return nil
//            }
//        }
//    }
//    
//    /**
//    Returns array of Mappable object if mapping succeeds and `nil` if mapping fails. The Array of object will be taken from the passed `keyPath`.
//    
//    - note: The default keyPath is "data".
//    */
//    public func mapResponseArray<T: Mappable>(to type: T.Type, keyPath: String = "") -> Observable<[T]?> {
//        
//        return self.map { (response: Response) -> [T]? in
//            
//            guard let JSON = try? response.mapJSON(),
//                let validJSON = JSON as? [String: Any],
//                let rawData = validJSON[keyPath] as? [[String: Any]] else {
//                    
//                    return nil
//            }
//            
//            return Mapper<T>().mapArray(JSONArray: rawData)
//        }
//    }
//
//    /**
//    Returns the passed Codable-compliant object if mapping succeeds and `nil` if fails.
//    */
//    public func map<T: Codable>(to type: T.Type) -> Observable<T?> {
//
//        return self.map { (response: Response) -> T? in
//
//            print("DebugRequest responValue \(response.data)")
//            guard let result = try? JSONDecoder().decode(ResponseData<T>.self, from: response.data) else {
//                print("DebugRequest return nil")
//                return nil
//            }
//
//            return result.data
//        }
//    }
//    
//    /**
//    Sends `next` event and true and false bool value if there's a valid value in passed `keyPath`, and `error` event if it's a `nil`.
//    
//    - note: The default value for keyPath is `data`.
//    */
//    public func flatMapResponseToBool(keyPath: String = "") -> Observable<Bool> {
//        
//        return self.map({ (response: Element) -> Bool? in
//            
//                guard let JSON = try? response.mapJSON(),
//                    let validJSON = JSON as? [String: Any] else {
//                        return nil
//                }
//            
//                return validJSON[keyPath] as? Bool
//            })
//            .flatMap({ (response: Bool?) -> Observable<Bool> in
//                
//                guard let response = response else {
//                    return Observable<Bool>.error(NetworkError.unknown)
//                }
//                
//                return Observable<Bool>.just(response)
//                
//            })
//    }
//    
//    /**
//    Sends `next` event with String value if there's a valid value in passed `keyPath`, and `error` event if it's a `nil`.
//    
//    - note: The default value for keyPath is `data`.
//    */
//    public func flatMapResponseToString(keyPath: String = "") -> Observable<String> {
//        
//        return self.map({ (response: Element) -> String? in
//            
//                guard let JSON = try? response.mapJSON(),
//                    let validJSON = JSON as? [String: String] else {
//                        return nil
//                }
//                return validJSON[keyPath]
//            })
//            .flatMap({ (response: String?) -> Observable<String> in
//                
//                guard let response = response else {
//                    return Observable<String>.error(NetworkError.unknown)
//                }
//                
//                return Observable<String>.just(response)
//                
//            })
//    }
//    
//}
