//
//  AuthViewModel.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import Foundation
import WebKit

final class AuthViewModel: NSObject, AuthViewModelProtocol {
    var completionHandler: ((Bool) -> Void)?
    weak var webView: WKWebView?
    
    init(completionHandler: @escaping (Bool) -> Void) {
        self.completionHandler = completionHandler
    }
    
    func fetch() {
        guard let url = AuthManager.shared.signInURL else {
            completionHandler?(false)
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
                self.completionHandler?(true)
            }
        case .failure(_):
            self.completionHandler?(false)
        }
    }
}
