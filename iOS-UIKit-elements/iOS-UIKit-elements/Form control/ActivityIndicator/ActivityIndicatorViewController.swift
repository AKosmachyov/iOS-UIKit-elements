//
//  ActivityIndicatorViewController.swift
//  iOS-UIKit-elements
//
//  Created by Alexander Kosmachyov on 3.05.23.
//

import Foundation

import UIKit

class ActivityIndicatorViewController: BaseListViewController {
    
    private let cellID = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableContent.append(contentsOf: [
            .init(title: "Medium tinted",
                  cellID: cellID,
                  configHandler: configureMediumActivityIndicatorView),
            .init(title: "Large",
                  cellID: cellID,
                  configHandler: configureLargeActivityIndicatorView),
            
//            .init(title: "Specific Keyboard",
//                  cellID: cellID,
//                  configHandler: configureSpecificKeyboardTextField),
//            .init(title: "Custom Text Field",
//                  cellID: customCellID,
//                  configHandler: configureCustomTextField)
        ])
    }
    
    override func targetView(_ cell: UITableViewCell) -> UIView? {
        return cell.contentView.subviews.first(where: { $0 is UITextField })
    }
    
    // MARK: - Configuration
    
    func configureMediumActivityIndicatorView(_ activityIndicator: UIActivityIndicatorView) {
        activityIndicator.style = .medium
        activityIndicator.color = UIColor.systemPurple
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.startAnimating()
    }
    
    func configureLargeActivityIndicatorView(_ activityIndicator: UIActivityIndicatorView) {
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true

        activityIndicator.startAnimating()
    }
}

fileprivate class BaseListCell: UITableViewCell {
    
}
