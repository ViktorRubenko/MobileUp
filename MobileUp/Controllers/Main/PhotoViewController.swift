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
        imageView.kf.indicatorType = .activity
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
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView
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
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
    }
    
    private func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    private func setupBinders() {
        viewModel.currentPhotoURL.bind { [weak self] url in
            guard let url = url else { return }
            self?.imageView.kf.setImage(with: url)
        }
        
        viewModel.bottomPhotos.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.dateString.bind { [weak self] value in
            self?.title = value
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup
            .horizontal(layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(56), heightDimension: .absolute(56)),
                        subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
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
// MARK: - Actions {
extension PhotoViewController {
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapShareButton() {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            self.savePhoto()
        }
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.sharePhoto()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        menu.addAction(saveAction)
        menu.addAction(shareAction)
        menu.addAction(cancelAction)
        
        present(menu, animated: true)
    }
    
    @objc func sharePhoto() {
        guard let url = viewModel.currentPhotoURL.value else { return }
        let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @objc func savePhoto() {
        HudView.instanceFromNib().run(inView: view)
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.bottomPhotos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(viewModel.bottomPhotos.value[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(itemIndex: indexPath.row)
    }
}
