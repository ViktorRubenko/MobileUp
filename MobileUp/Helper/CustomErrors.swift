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

enum AuthManagerError: Error {
    case tokenIsExpired
    case unknown
}

extension AuthManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .tokenIsExpired:
            return NSLocalizedString("Token expired! Need to relog.", comment: "Description for TokenExpiredError.")
        case .unknown:
            return NSLocalizedString("Something go wrong...", comment: "Description for unknown error.")
        }
    }
}
