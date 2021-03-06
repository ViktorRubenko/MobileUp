//
//  AuthViewModel.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import Foundation
import WebKit

final class AuthViewModel: NSObject, AuthViewModelProtocol {
    private(set) var isSignIn = false
    var loadCompletion: (() -> Void)?
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
        clearWKDataStore()
        webView?.load(URLRequest(url: url))
    }
    
    private func clearWKDataStore() {
        WKWebsiteDataStore.default().removeData(
            ofTypes: [WKWebsiteDataTypeCookies],
            modifiedSince: Date(timeIntervalSince1970: 0),
            completionHandler: {})
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
                self.isSignIn = true
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadCompletion?()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadCompletion?()
    }
}
