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
        updatePhoto()
        updateDateString()
        if bottomPhotos.value.isEmpty {
            updateBottomPhotos()
        }
    }
    
    func didSelectItem(itemIndex: Int) {
        currentPhotoIndex = itemIndex
        fetch()
    }
    
    private func updatePhoto() {
        guard let url = findClosestSizeImage(
            imageSizes: currentPhoto.sizes, requiredSize: CGSize(width: 1000, height: 1000)) else {
                return
            }
        currentPhotoURL.value = URL(string: url)
    }
    
    private func updateBottomPhotos() {
        bottomPhotos.value = photoResponses.compactMap {
            guard let url = findClosestSizeImage(
                imageSizes: $0.sizes, requiredSize: CGSize(width: 200, height: 200)) else {
                    return nil
                }
            return PhotoCellModel(url: url)
        }
    }
    
    private func updateDateString() {
        let date = Date(timeIntervalSince1970: Double(currentPhoto.date))
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "d MMMM yyyy"
        dateString.value = formatter.string(from: date)
    }
}
