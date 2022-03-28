//
//  PhotoViewController.swift
//  MobileUp
//
//  Created by Victor Rubenko on 29.03.2022.
//

import UIKit
import SwiftUI

class PhotoViewController: UIViewController {
    
    private var viewModel: PhotoViewModelProtocol!
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        return scrollView
    }()
    
    init(viewModel: PhotoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationItem()
        setupBinders()
        
        viewModel.fetch()
    }
}
// MARK: - Methods
extension PhotoViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(scrollView.snp.width)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView)
            make.center.equalTo(scrollView)
        }
        
    }
    
    private func setupNavigationItem() {
        
    }
    
    private func setupBinders() {
        viewModel.currentPhotoURL.bind { [weak self] url in
            guard let url = url else { return }
            self?.imageView.kf.setImage(with: url)
        }
    }
}
// MARK: - UIScrollViewDelegate
extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        
        imageView.center = CGPoint(
            x: scrollView.contentSize.width * 0.5 + offsetX,
            y: scrollView.contentSize.height * 0.5 + offsetY)
    }
}
