//
//  AuthViewModelProtocol.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import Foundation
import WebKit

protocol AuthViewModelProtocol: ViewModelProtocol, WKNavigationDelegate {
    var isSignIn: Bool { get }
    var webView: WKWebView? { get set }
    var completionHandler: ((Result<Bool, AuthError>) -> Void)? { get set }
    var loadCompletion: (() -> Void)? { get set }
}
