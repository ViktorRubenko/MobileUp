//
//  WelcomeViewController.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let authButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            NSLocalizedString("Auth via VK", comment: "AuthButton title"),
            for: .normal)
        button.setTitleColor(Constants.Colors.authButtonTint, for: .normal)
        button.backgroundColor = Constants.Colors.authButtonBackground
        button.titleLabel?.font = Constants.Fonts.authButtonFont
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mobile Up\nGallery"
        label.font = Constants.Fonts.titleLabelFont
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var authCoordinator = AuthCoordinator(presenter: self)
    
    private var setupLayouts = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
    
    override func viewDidLayoutSubviews() {
        if setupLayouts {
            setupLayouts = false
            authButton.layer.cornerRadius = authButton.bounds.height * 0.15
        }
    }
}
// MARK: - Methods
extension WelcomeViewController {
    private func setupUI() {

        view.backgroundColor = Constants.Colors.viewBackground
        
        view.addSubview(titleLabel)
        view.addSubview(authButton)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(164)
        }
        
        authButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
    }
    
    private func setupActions() {
        authButton.addTarget(self, action: #selector(didTapAuthButton), for: .touchUpInside)
    }
    
    func showAuthError(message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("Error", comment: "Alert title."),
            message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
// MARK: - Actions
extension WelcomeViewController {
    @objc func didTapAuthButton() {
        authCoordinator.start()
    }
}
