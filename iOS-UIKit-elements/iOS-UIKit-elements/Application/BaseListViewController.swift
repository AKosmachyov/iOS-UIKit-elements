//
//  BaseListViewController.swift
//  iOS-UIKit-elements
//
//  Created by Alexander Kosmachyov on 2.05.23.
//

import Foundation
import UIKit

struct TableElement {
    var title: String
    var cellID: String
    
    typealias ConfigurationClosure = (UIView) -> Void
    var configHandler: ConfigurationClosure
    
    init<V: UIView>(title: String, cellID: String, configHandler: @escaping (V) -> Void) {
        self.title = title
        self.cellID = cellID
        self.configHandler = { view in
            guard let view = view as? V else { fatalError("Unable to convert to Type") }
            configHandler(view)
        }
    }
}

class BaseListViewController: UITableViewController {
    // List of table view cell
    var tableContent = [TableElement]()
    typealias CellConfiguration = (_ cell: UITableViewCell, _ item: TableElement) -> Void
    var baseConfiguration: CellConfiguration?
    
    func targetView(_ cell: UITableViewCell) -> UIView? {
        return cell.contentView.subviews[0]
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellContent = tableContent[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellContent.cellID, for: indexPath)
        if let baseConfiguration {
            baseConfiguration(cell, cellContent)
        }
        if let view = targetView(cell) {
            cellContent.configHandler(view)
        }
        return cell
    }
}
