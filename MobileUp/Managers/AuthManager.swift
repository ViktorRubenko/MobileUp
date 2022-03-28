//
//  AuthManager.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import Foundation

final class AuthManager {
    
    private enum Constants {
        static let clientID = "8118560"
        static let redirectURI = "https://oauth.vk.com/blank.html"
        static let responseType = "token"
        static let display = "mobile"
        static let authURL = "https://oauth.vk.com/authorize"
    }
    
    private enum Keys: String {
        case accessToken, refreshToken, expirationDate
    }
    
    static let shared = AuthManager()
    
    private init() {}
    
    private var accessToken: String? {
        UserDefaults.standard.string(forKey: Keys.accessToken.rawValue)
    }
    
    private var expirationDate: Date? {
        UserDefaults.standard.value(forKey: Keys.expirationDate.rawValue) as? Date
    }
    
    private var accessTokenIsValid: Bool {
        guard let expirationDate = expirationDate else {
            return false
        }
        return Date().addingTimeInterval(60 * 10) <= expirationDate
    }
    
    public var isSignIn: Bool {
        accessToken != nil && accessTokenIsValid
    }
    
    public var signInURL: URL? {
        var components = URLComponents(string: Constants.authURL)
        
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.clientID),
            URLQueryItem(name: "display", value: Constants.display),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: Constants.responseType),
        ]
        
        return components?.url
    }
    
    public func getAccessToken(_ urlString: String) -> Result<Bool, AuthError> {
        if !urlString.starts(with: Constants.redirectURI) {
            return .success(false)
        }
        let sanitizedURL = urlString.replacingOccurrences(of: "#", with: "?")
        let items = URLComponents(string: sanitizedURL)?.queryItems
        guard let accessToken = items?.first(where: { $0.name == "access_token" })?.value else {
            return .failure(.authError)
        }
        guard let expiresIn = items?.first(where: { $0.name == "expires_in" })?.value,
                let intExpiresIn = Int(expiresIn) else {
            return .failure(.authError)
        }
        
        AuthManager.shared.setAcessToken(accessToken: accessToken, expiresIn: intExpiresIn)
        return .success(true)
    }
    
    private func setAcessToken(accessToken: String, expiresIn: Int) {
        UserDefaults.standard.set(accessToken, forKey: Keys.accessToken.rawValue)
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(expiresIn)), forKey: Keys.expirationDate.rawValue)
    }
    
    public func sightOut() {
        UserDefaults.standard.removeObject(forKey: Keys.accessToken.rawValue)
        UserDefaults.standard.removeObject(forKey: Keys.expirationDate.rawValue)
    }
    
    public func withValidToken(completion: @escaping (Result<String, AuthManagerError>) -> Void) {
        guard accessTokenIsValid else {
            completion(.failure(AuthManagerError.tokenIsExpired))
            return
        }
        guard let accessToken = accessToken else {
            completion(.failure(AuthManagerError.unknown))
            return
        }
        completion(.success(accessToken))
    }
}
