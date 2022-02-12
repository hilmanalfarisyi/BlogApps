//
//  ResponseData.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 12/02/22.
//


import Foundation

public struct ResponseData<T: Codable>: Codable {

    public let data: T

}

