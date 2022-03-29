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
    private let activityIndicator = UIActivityIndicatorView()
    
    init(viewModel: AuthViewModelProtocol) {
        self.viewModel = viewModel
        self.viewModel.webView = webView
        webView.navigationDelegate = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.loadCompletion = { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.fetch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard !viewModel.isSignIn else { return }
        let alert = UIAlertController(
            title: NSLocalizedString("Error", comment: "Alert title."),
            message: NSLocalizedString("Authorization session was closed.", comment: "Autorization session closed error."),
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        presentingViewController?.present(alert, animated: true)
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
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
    }
}
