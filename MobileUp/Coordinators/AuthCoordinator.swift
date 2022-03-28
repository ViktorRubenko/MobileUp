//
//  AuthCoordinator.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import Foundation
import UIKit

final class AuthCoordinator: CoordinatorProtocol {
    private weak var presenter: WelcomeViewController?
    
    init(presenter: WelcomeViewController) {
        self.presenter = presenter
    }
    
    func start() {
        let viewModel = AuthViewModel(completionHandler: { [weak self] success in
            if success {
                self?.presenter?.dismiss(animated: true, completion: {
                    let vc = NavigationController()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate?)??.changeRootViewController(vc)
                })
            } else {
                self?.presenter?.dismiss(animated: true, completion: { self?.presenter?.showAuthError() })
            }
        })
        let vc = AuthViewController(viewModel: viewModel)
        presenter?.present(vc, animated: true, completion: nil)
    }
}
