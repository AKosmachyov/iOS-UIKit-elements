//
//  MenuViewController.swift
//  iOS-UIKit-elements
//
//  Created by Alexander Kosmachyov on 30.10.22.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MenuItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MenuItem>
    
    var collectionView: UICollectionView! = nil
    var dataSource: DataSource! = nil
    
    var isEnoughSpaceForDetails: Bool {
        return splitViewController?.traitCollection.horizontalSizeClass == .regular
    }
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        #if DEBUG
        let item = MenuItem(title: "Grid", imageName: nil, viewController: GridViewController.self)
        showItem(item)
        #endif
    }
    
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
        self.collectionView = collectionView
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
    
    private func configureDataSource() {
        let containerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MenuItem> { (cell, indexPath, menuItem) in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = menuItem.title
            
            if let image = menuItem.imageName {
                contentConfiguration.image = UIImage(systemName: image)
            }
            
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration
            
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
            
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MenuItem> { cell, indexPath, menuItem in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = menuItem.title
            
            if let image = menuItem.imageName {
                contentConfiguration.image = UIImage(systemName: image)
            }
            
            cell.contentConfiguration = contentConfiguration
            
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
            
            cell.accessories = self.isEnoughSpaceForDetails ? [] : [.disclosureIndicator()]
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            if item.subItems.isEmpty {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: containerCellRegistration, for: indexPath, item: item)
            }
        }
        
        // Load initial data.
        let snapshot = initialSnapshot()
        dataSource.apply(snapshot, to: .main, animatingDifferences: false)
    }
    
    private func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<MenuItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<MenuItem>()
        
        func addItems(_ menuItems: [MenuItem], to parent: MenuItem?) {
            snapshot.append(menuItems, to: parent)
            for menuItem in menuItems where !menuItem.subItems.isEmpty {
                addItems(menuItem.subItems, to: menuItem)
            }
        }
        
        addItems(MenuContent().menuItems, to: nil)
        return snapshot
    }
}

// MARK: - UICollectionViewDelegate

extension MenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = dataSource.itemIdentifier(for: indexPath) else { return }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        showItem(menuItem)
    }
    
    private func showItem(_ menuItem: MenuItem) {
        if let storyboardName = menuItem.storyboardName {
            pushOrPresentStoryboard(storyboardName: storyboardName, storyboardID: menuItem.storyboardID)
            return
        }
        
        if let viewControllerType = menuItem.viewController {
            pushOrPresentViewController(viewController: viewControllerType.init())
        }
    }
    
    private func pushOrPresentStoryboard(storyboardName: String, storyboardID: String?) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        if let storyboardID {
            let vc = storyboard.instantiateViewController(withIdentifier: storyboardID)
            pushOrPresentViewController(viewController: vc)
            return
        }
        
        if let exampleViewController = storyboard.instantiateInitialViewController() {
            pushOrPresentViewController(viewController: exampleViewController)
        }
    }
    
    private func pushOrPresentViewController(viewController: UIViewController) {
        if isEnoughSpaceForDetails {
            let navVC = UINavigationController(rootViewController: viewController)
            splitViewController?.showDetailViewController(navVC, sender: navVC) // Replace the detail view controller.
        } else {
            navigationController?.pushViewController(viewController, animated: true) // Just push instead of replace.
        }
    }
}
