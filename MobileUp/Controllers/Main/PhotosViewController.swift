//
//  PhotosViewController.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import UIKit

class PhotosViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, enviroment in
            self.createSection(sectionIndex, enviroment)
        }))
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure("https://picsum.photos/600/600")
        return cell
    }
}
