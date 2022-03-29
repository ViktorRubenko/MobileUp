//
//  PhotosViewController.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import UIKit

class PhotosViewController: UIViewController {
    
    private var viewModel: PhotosViewModelProtocol!
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
                sectionIndex, enviroment in
                self.createSection(sectionIndex, enviroment)
            }))
        collectionView.register(
            PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    init(viewModel: PhotosViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
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
extension PhotosViewController {
    func setupUI() {
        view.backgroundColor = Constants.Colors.viewBackground
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupBinders() {
        viewModel.photos.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.errorMessage.bind { [weak self] errorDescription in
            let alert = UIAlertController(
                title: NSLocalizedString("Error", comment: "Alert title."),
                message: errorDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    func createSection(_ sectionIndex: Int, _ environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let width = environment.container.effectiveContentSize.width
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup
            .horizontal(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute((width - 2) / 2.0)),
                        subitem: item,
                        count: 2)
        group.interItemSpacing = .fixed(2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        
        return section
    }
    
    func setupNavigationItem() {
        title = "Mobile UP Gallery"
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium),
        ]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("Exit", comment: "Exit button title."),
            style: .plain,
            target: self,
            action: #selector(didTapExitButton))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Colors.tint
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium),
            ], for: .normal)
    }
}
// MARK: - Actions
extension PhotosViewController {
    @objc func didTapExitButton() {
        ExitCoordinator().start()
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(viewModel.photos.value[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PhotoCoordinator(from: self, startPhotoIndex: indexPath.row, photoResponses: viewModel.photoResponses).start()
    }
}
