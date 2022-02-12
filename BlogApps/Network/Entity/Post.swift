//
//  Post.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 11/02/22.
//

import Foundation

struct Post: Codable {
    
    let id: Int
    let title, content, publishedAt, createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, title, content
        case publishedAt = "published_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
