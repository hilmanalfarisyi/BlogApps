//
//  RequestManager.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 11/02/22.
//


import Foundation
import Alamofire
import netfox


public final class RequestManager {

    /**
    Return a shared instance of Alamofire.Manager class. If target build is DEV or STAGING,
    then it'll be configured with NFXProtocol so netfox service will run to log all network request
    
    - return: Alamofire.Manager
    */
    public static func sharedInstance() -> Alamofire.Session {

        return NFXNetwork.sharedManager
    }
}

final private class NFXNetwork: Alamofire.Session {

    static let sharedManager: NFXNetwork = {

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(NFXProtocol.self, at: 0)
        configuration.httpAdditionalHeaders = Alamofire.HTTPHeaders.default.dictionary
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30

        return NFXNetwork(configuration: configuration)
    }()

}


final private class ProdNetwork: Alamofire.Session {

    static let sharedManager: ProdNetwork = {

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.HTTPHeaders.default.dictionary
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30

        return ProdNetwork(configuration: configuration)
    }()

}

