//
//  PhotoCollectionViewCell.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import UIKit
import Kingfisher

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoReusableView"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
// MARK: - Methods
extension PhotoCollectionViewCell {
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(_ model: PhotoCellModel) {
        let url = URL(string: model.url)
//        let proccessor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            options: [
//                .processor(proccessor),
//                .transition(.fade(0.2)),
                .cacheOriginalImage
            ])
    }
}
