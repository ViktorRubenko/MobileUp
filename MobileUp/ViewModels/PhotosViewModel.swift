//
//  PhotosViewModel.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import UIKit

final class PhotosViewModel: PhotosViewModelProtocol {
    private (set) var photoResponses = [ImageItem]()
    let photos = Observable<[PhotoCellModel]>([])
    let errorMessage = Observable<String>("")
    
    func fetch() {
        getPhotos()
    }
    
    private func getPhotos() {
        APICaller.shared.getPhotos { result in
            switch result {
            case .success(let photosResponse):
                guard let response = photosResponse.response else {
                    self.errorHandler(APIError.responseError)
                    return
                }
                self.photos.value = response.items.compactMap {
                    guard let url = findClosestSizeImage(imageSizes: $0.sizes, requiredSize: CGSize(width: 500, height: 500)) else {
                        return nil
                    }
                    return PhotoCellModel(url: url)
                }
                self.photoResponses = response.items
            case .failure(let error):
                self.errorHandler(error)
            }
        }
    }
    
    private func errorHandler(_ error: Error) {
        errorMessage.value = error.localizedDescription
    }
}
