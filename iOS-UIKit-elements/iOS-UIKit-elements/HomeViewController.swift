//
//  HomeViewController.swift
//  iOS-UIKit-elements
//
//  Created by Alexander Kosmachyov on 10.03.22.
//

import UIKit

class HomeViewController: UITableViewController {
    var array = [
        [("Form control", nil), ("UITextField", nil), ("UIButton", nil)],
        [("Layout Containers", nil), ("UICollectionViewController", "collectionViewController")],
        [("Content View", nil)]
    ]
    
    typealias ListItem = (title: String, storyboardId: String?)
}

extension HomeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array[section].count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "home-cell", for: indexPath) as UITableViewCell
        let tuple = array[indexPath.section][indexPath.row + 1]
        cell.textLabel?.text = tuple.0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return array[section][0].0
    }
}

extension HomeViewController: UICollectionViewDelegate {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tuple = array[indexPath.section][indexPath.row + 1]
        guard let id = tuple.1 else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: id)
        navigationController?.pushViewController(controller, animated: true)
    }
}
