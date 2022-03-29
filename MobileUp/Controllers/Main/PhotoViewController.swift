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
        imageView.tintColor = Constants.Colors.tint.withAlphaComponent(0.5)
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
    
    private var showImageError = true
    private var allowToSave = false
    
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
        setupGestureRecognizers()
        setupBinders()
        
        viewModel.fetch()
    }
}
// MARK: - Methods
extension PhotoViewController {
    private func setupUI() {
        view.backgroundColor = Constants.Colors.viewBackground
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
            image: UIImage(
                systemName: "chevron.left",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)),
            style: .done,
            target: self,
            action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Colors.tint
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: "square.and.arrow.up",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)),
            style: .plain,
            target: self,
            action: #selector(didTapShareButton))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Colors.tint
    }
    
    private func setupBinders() {
        viewModel.currentPhotoURL.bind { [weak self] url in
            guard let url = url else { return }
            self?.imageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success(_):
                    self?.allowToSave = true
                case .failure(_):
                    self?.imageView.image = UIImage(systemName: "photo.circle.fill")
                    self?.allowToSave = false
                    self?.showImageAlert()
                }
            }
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
    
    private func setupGestureRecognizers() {
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        leftSwipeRecognizer.direction = .left
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
        rightSwipeRecognizer.direction = .right
        
        scrollView.addGestureRecognizer(leftSwipeRecognizer)
        scrollView.addGestureRecognizer(rightSwipeRecognizer)
    }
}
// MARK: - UIScrollViewDelegate
extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale == 1.0 {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
        
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        
        imageView.center = CGPoint(
            x: scrollView.contentSize.width * 0.5 + offsetX,
            y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
    func showImageAlert() {
        guard showImageError else { return }
        showImageError = false
        let alert = UIAlertController(
            title: NSLocalizedString("Error", comment: "Alert title."),
            message: NSLocalizedString("Failed to load image.", comment: "Fail image error description."),
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
// MARK: - Actions {
extension PhotoViewController {
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapShareButton() {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(
            title: NSLocalizedString("Save", comment: "Save photo action."),
            style: .default) { _ in
            self.savePhoto()
        }
        let shareAction = UIAlertAction(
            title: NSLocalizedString("Share", comment: "Share photo action."),
            style: .default) { _ in
            self.sharePhoto()
        }
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Cancel", comment: "Cancel photo action."),
            style: .cancel,
            handler: nil)
        
        if allowToSave {
            menu.addAction(saveAction)
        }
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
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            HudView.instanceFromNib().run(inView: view)
        } else {
            let alert = UIAlertController(
                title: NSLocalizedString("Error", comment: "Alert title."),
                message: NSLocalizedString("App needs access to the gallery to save photos.", comment: "Gallery access error message."),
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    @objc func didSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        showImageError = true
        viewModel.swipeNext(sender.direction)
    }
    
    @objc func didSwipeRight(_ sender: UISwipeGestureRecognizer) {
        showImageError = true
        viewModel.swipeNext(sender.direction)
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.bottomPhotos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        if cell.configure(viewModel.bottomPhotos.value[indexPath.row]) != nil, showImageError {
            showImageAlert()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(itemIndex: indexPath.row)
    }
}
