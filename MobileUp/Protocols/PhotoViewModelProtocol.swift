//
//  PhotoViewModelProtocol.swift
//  MobileUp
//
//  Created by Victor Rubenko on 29.03.2022.
//

import Foundation

protocol PhotoViewModelProtocol: ViewModelProtocol {
    var bottomPhotos: Observable<[PhotoCellModel]> { get }
    var currentPhotoURL: Observable<String> { get }
    var dateString: Observable<String> { get }
}
