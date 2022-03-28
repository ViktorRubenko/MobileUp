//
//  Functions.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import UIKit

func findClosestSizeImage(
    imageSizes: [ImageSize],
    requiredSize: CGSize) -> String? {
        
        func distance(_ imageSize: ImageSize) -> Double {
            let height = Double(imageSize.height)
            let width = Double(imageSize.width)
            
            return sqrt(pow(requiredSize.height - height, 2) + pow(requiredSize.width - width, 2))
        }
        
        guard !imageSizes.isEmpty else {
            return nil
        }
        
        if imageSizes.count == 1 {
            return imageSizes[0].url
        }
        print(imageSizes.compactMap { (size: $0, distance: distance($0)) }.sorted { $0.distance < $1.distance })
        let closestSize = imageSizes.compactMap { (size: $0, distance: distance($0)) }.sorted { $0.distance < $1.distance }.first!.size
        return closestSize.url
    }
