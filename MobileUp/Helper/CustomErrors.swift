//
//  Erorrs.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import Foundation

enum AuthError: Error {
    case authError
    case connectionError
    case unknown
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .authError, .unknown:
            return NSLocalizedString("Authorization Failed.", comment: "Description for failed auth.")
        case .connectionError:
            return NSLocalizedString("Connection Error.", comment: "Description for connection error.")
        }
    }
}
