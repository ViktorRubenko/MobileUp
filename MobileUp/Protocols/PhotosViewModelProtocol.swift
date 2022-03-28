//
//  PhotosViewModelProtocol.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import Foundation

protocol PhotosViewModelProtocol: ViewModelProtocol {
    var photoResponses: [ImageItem] { get }
    var photos: Observable<[PhotoCellModel]> { get }
    var errorMessage: Observable<String> { get }
}
