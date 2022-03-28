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
        let viewModel = AuthViewModel(completionHandler: { [weak self] result in
            switch result {
            case .success(_):
                self?.presenter?.dismiss(animated: true, completion: {
                    let vc = NavigationController()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate?)??.changeRootViewController(vc)
                })
            case .failure(let error):
                self?.presenter?.dismiss(animated: true, completion: { self?.presenter?.showAuthError(message: error.localizedDescription) })
            }
        })
        let vc = AuthViewController(viewModel: viewModel)
        presenter?.present(vc, animated: true, completion: nil)
    }
}
