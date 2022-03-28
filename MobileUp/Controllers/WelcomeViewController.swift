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
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
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

        view.backgroundColor = .white
        
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
}
// MARK: - Actions
extension WelcomeViewController {
    @objc func didTapAuthButton() {
        
    }
}
