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
            self?.presenter?.dismiss(animated: true, completion: success ? nil : { self?.presenter?.showAuthError() })
        })
        let vc = AuthViewController(viewModel: viewModel)
        presenter?.present(vc, animated: true, completion: nil)
    }
}
