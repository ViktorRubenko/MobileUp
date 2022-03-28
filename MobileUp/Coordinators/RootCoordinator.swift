//
//  RootCoordinator.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import UIKit

final class RootCoordinator: CoordinatorProtocol {
    func start() {
        let vc: UIViewController
        if AuthManager.shared.isSignIn {
            vc = UINavigationController(rootViewController: PhotosViewController(viewModel: PhotosViewModel()))
        } else {
            vc = WelcomeViewController()
        }
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate?)??.setRootViewController(vc)
    }
}
