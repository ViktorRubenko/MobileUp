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
    let responseError: ErrorResponse?
    
    enum CodingKeys: String, CodingKey {
        case response
        case responseError = "error"
    }
}

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let errorCode: Int?
    let errorMsg: String?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMsg = "error_msg"
    }
}

// MARK: - Response
struct Response: Codable {
    let items: [ImageItem]
}

// MARK: - Item
struct ImageItem: Codable {
    let date, id: Int
    let sizes: [ImageSize]
    let text: String
}

// MARK: - Size
struct ImageSize: Codable {
    let url: String
    let width: Int
    let height: Int
}
