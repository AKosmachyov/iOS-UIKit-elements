//
//  GridViewController.swift
//  iOS-UIKit-elements
//
//  Created by Alexander Kosmachyov on 11.05.23.
//

import UIKit

class GridViewController: UIViewController {
    enum Section {
        case main
    }
    var lastEl: Int = 2
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Grid"
        configureHierarchy()
        configureDataSource()
    }
}

extension GridViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reload",
                                                            style: .plain, target: self,
                                                            action: #selector(didPressReload))
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<GridCell, String> { (cell, indexPath, identifier) in
            cell.configure(text: "\(identifier)")
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(["1", "2", "3"])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc func didPressReload() {
        var snapshot = dataSource.snapshot()
        
        let a = String(UUID().uuidString.prefix(6))
        print("Add", a)
        snapshot.appendItems([a])
        dataSource.apply(snapshot)
    }
}

class GridCell: UICollectionViewCell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

    func setupUI() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        contentView.addSubview(label)
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
//        contentView.backgroundColor = .lightGray
        contentView.backgroundColor = UIColor(red: 0, green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    }
    
    func configure(text: String) {
        label.text = text
    }
}
