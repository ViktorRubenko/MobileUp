//
//  PhotosViewModel.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import UIKit

final class PhotosViewModel: PhotosViewModelProtocol {
    let photos = Observable<[PhotoCellModel]>([])
    
    func fetch() {
        getPhotos()
    }
    
    private func getPhotos() {
        APICaller.shared.getPhotos { result in
            switch result {
            case .success(let photosResponse):
                guard let response = photosResponse.response else {
                    print(photosResponse.responseError?.errorMsg)
                    return
                }
                self.photos.value = response.items.compactMap {
                    guard let url = findClosestSizeImage(imageSizes: $0.sizes, requiredSize: CGSize(width: 200, height: 200)) else {
                        return nil
                    }
                    return PhotoCellModel(url: url)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
