//
//  PhotoCoordinator.swift
//  MobileUp
//
//  Created by Victor Rubenko on 29.03.2022.
//

import Foundation
import UIKit

final class PhotoCoordinator: CoordinatorProtocol {
    
    private var startPhotoIndex: Int
    private var photoResponses: [ImageItem]
    private var from: UIViewController
    
    init(from: UIViewController,startPhotoIndex: Int, photoResponses: [ImageItem]) {
        self.startPhotoIndex = startPhotoIndex
        self.photoResponses = photoResponses
        self.from = from
    }
    
    func start() {
        let viewModel = PhotoViewModel(startPhotoIndex: startPhotoIndex, photoResponses: photoResponses)
        let vc = PhotoViewController(viewModel: viewModel)
        from.navigationController?.pushViewController(vc, animated: true)
    }
}
