//
//  PhotosResponseModel.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import Foundation

// MARK: - PhotosResponseModel
struct PhotosResponseModel: Codable {
    let response: Response?
    let errorCode: Int?
    let errorMsg: String?
    
    enum CodingKeys: String, CodingKey {
        case response
        case errorCode = "error_code"
        case errorMsg = "error_msg"
    }
}

// MARK: - Response
struct Response: Codable {
    let count: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let albumID, date, id, ownerID: Int
    let sizes: [Size]
    let text: String
    let userID: Int
    let hasTags: Bool

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case sizes, text
        case userID = "user_id"
        case hasTags = "has_tags"
    }
}

// MARK: - Size
struct Size: Codable {
    let height: Int
    let url: String
    let type: String
    let width: Int
}
