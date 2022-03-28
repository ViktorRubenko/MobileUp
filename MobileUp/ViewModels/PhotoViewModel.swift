//
//  PhotoViewModel.swift
//  MobileUp
//
//  Created by Victor Rubenko on 29.03.2022.
//

import UIKit

final class PhotoViewModel: PhotoViewModelProtocol {
    private var photoResponses: [ImageItem]
    private var currentPhotoIndex: Int
    private var currentPhoto: ImageItem {
        photoResponses[currentPhotoIndex]
    }
    
    let bottomPhotos = Observable<[PhotoCellModel]>([])
    let currentPhotoURL = Observable<URL?>(nil)
    let dateString = Observable<String?>(nil)
    
    init(startPhotoIndex: Int, photoResponses: [ImageItem]) {
        currentPhotoIndex = startPhotoIndex
        self.photoResponses = photoResponses
    }
    
    func fetch() {
        updateImage()
    }
    
    private func updateImage(){
        guard let url = findClosestSizeImage(imageSizes: currentPhoto.sizes, requiredSize: CGSize(width: 5000, height: 5000)) else {
            return
        }
        currentPhotoURL.value = URL(string: url)
    }
}