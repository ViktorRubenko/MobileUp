//
//  NavigationController.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import UIKit

class PhotosNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [PhotosViewController()]
    }
}
