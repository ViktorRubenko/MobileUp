//
//  ExitCoordinator.swift
//  MobileUp
//
//  Created by Victor Rubenko on 29.03.2022.
//

import UIKit

final class ExitCoordinator {
    func start() {
        AuthManager.shared.sightOut()
        
        let vc = WelcomeViewController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate?)??.changeRootViewController(vc)
    }
}
