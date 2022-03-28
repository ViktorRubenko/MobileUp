//
//  AuthViewModelProtocol.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import Foundation
import WebKit

protocol AuthViewModelProtocol: ViewModelProtocol, WKNavigationDelegate {
    var webView: WKWebView? { get set }
    var completionHandler: ((Bool) -> Void)? { get set }
}
