//
//  OptionalType.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 12/02/22.
//

import Foundation

// Reference for the proxy protocol: https://stackoverflow.com/a/33139228/1448626

/**
Protocol for `Optional`'s bare requirements to allow creation of Optional-related protocols
*/
public protocol OptionalType {
    
    associatedtype Wrapped
    
    func map<U>(_ f: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: OptionalType {}

extension OptionalType {
    
    /**
    Proxy property to allow extensions use Optional normally.
    */
    public var optionalValue: Wrapped? {
        
        return self.map { (value: Wrapped) -> Wrapped in
            return value
        }
    }
}
