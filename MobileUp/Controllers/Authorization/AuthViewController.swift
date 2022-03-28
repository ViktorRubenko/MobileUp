//
//  AuthViewController.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {

    private let viewModel: AuthViewModelProtocol!
    private let webView = WKWebView()
    
    init(viewModel: AuthViewModelProtocol) {
        self.viewModel = viewModel
        self.viewModel.webView = webView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        webView.navigationDelegate = viewModel
        viewModel.fetch()
    }
}
// MARK: - Methods
extension AuthViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
