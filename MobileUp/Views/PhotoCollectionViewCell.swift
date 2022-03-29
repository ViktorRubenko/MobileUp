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
        imageView.tintColor = Constants.Colors.tint.withAlphaComponent(0.5)
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
    
    func configure(_ model: PhotoCellModel) -> KingfisherError? {
        let url = URL(string: model.url)
        var imageError: KingfisherError?
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                imageError = error
                self?.imageView.image = UIImage(systemName: "photo.circle.fill")
            }
        }
        return imageError
    }
}
