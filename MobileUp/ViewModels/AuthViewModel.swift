//
//  AuthViewModel.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import Foundation
import WebKit

final class AuthViewModel: NSObject, AuthViewModelProtocol {
    var completionHandler: ((Result<Bool, AuthError>) -> Void)?
    weak var webView: WKWebView?
    
    init(completionHandler: @escaping (Result<Bool, AuthError>) -> Void) {
        self.completionHandler = completionHandler
    }
    
    func fetch() {
        guard let url = AuthManager.shared.signInURL else {
            completionHandler?(.failure(AuthError.unknown))
            return
        }
        webView?.load(URLRequest(url: url))
    }
}

extension AuthViewModel: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        switch AuthManager.shared.getAccessToken(url.absoluteString) {
        case .success(let finished):
            if finished {
                self.completionHandler?(.success(true))
            }
        case .failure(_):
            self.completionHandler?(.failure(AuthError.authError))
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if (error as NSError).code == -1009 {
            completionHandler?(.failure(AuthError.connectionError))
            return
        }
        completionHandler?(.failure(AuthError.unknown))
    }
}
