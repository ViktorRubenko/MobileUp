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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, enviroment in
            self.createSection(sectionIndex, enviroment)
        }))
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
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
        setupBinders()
        
        viewModel.fetch()
    }
}
// MARK: - Methods
extension PhotosViewController {
    func setupUI() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    
    func setupBinders() {
        viewModel.photos.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.errorMessage.bind { [weak self] errorDescription in
            let alert = UIAlertController(title: "Error", message: errorDescription, preferredStyle: .alert)
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
                heightDimension: .absolute(width / 2.0)),
                        subitem: item,
                        count: 2)
        group.interItemSpacing = .fixed(2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        
        return section
    }
}
// MARK: -
extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(viewModel.photos.value[indexPath.row])
        return cell
    }
}
