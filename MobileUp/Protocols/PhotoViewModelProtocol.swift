//
//  PhotoViewModelProtocol.swift
//  MobileUp
//
//  Created by Victor Rubenko on 29.03.2022.
//

import UIKit

protocol PhotoViewModelProtocol: ViewModelProtocol {
    var bottomPhotos: Observable<[PhotoCellModel]> { get }
    var currentPhotoURL: Observable<URL?> { get }
    var dateString: Observable<String?> { get }
    
    func didSelectItem(itemIndex: Int)
    func swipeNext(_ swipeDirection: UISwipeGestureRecognizer.Direction)
}
