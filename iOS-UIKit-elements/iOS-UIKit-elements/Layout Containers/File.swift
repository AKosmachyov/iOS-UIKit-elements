//
//  File.swift
//  iOS-UIKit-elements
//
//  Created by Alexander Kosmachyov on 3.05.23.
//

import Foundation

//class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!
//
//let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
//    "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
//    "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
//    "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
//    "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
//
//var filteredData: [String]!
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//    tableView.dataSource = self
//    searchBar.delegate = self
//    filteredData = data
//}
//
//func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as UITableViewCell
//    cell.textLabel?.text = filteredData[indexPath.row]
//    return cell
//}
//
//func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return filteredData.count
//}
//
//// This method updates filteredData based on the text in the Search Box
//func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//    // When there is no text, filteredData is the same as the original data
//    // When user has entered text into the search box
//    // Use the filter method to iterate over all items in the data array
//    // For each item, return true if the item should be included and false if the
//    // item should NOT be included
//    filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
//        // If dataItem matches the searchText, return true to include it
//        return dataString.range(of: searchText, options: .caseInsensitive) != nil
//    })
//
//    tableView.reloadData()
//}
//}
//
//
//let searchBar: UISearchBar = {
//
//        let searchBar = UISearchBar()
//        searchBar.tintColor = UIColor.black.withAlphaComponent(1.0)
//        searchBar.placeholder = "Search for exercise"
//        searchBar.backgroundColor = UIColor.clear
//        searchBar.barTintColor = UIColor.clear
//        searchBar.searchBarStyle = .minimal
//        searchBar.returnKeyType = .search
//        searchBar.showsCancelButton = false
//        searchBar.showsBookmarkButton = false
//        searchBar.sizeToFit()
//
//        return searchBar
//    }()
//
//@IBOutlet weak var collectionView: UICollectionView!
//
//var refresher:UIRefreshControl!
//
//override func viewDidLoad() {
//
//   super.viewDidLoad()
//
//    self.refresher = UIRefreshControl()
//    self.collectionView!.alwaysBounceVertical = true
//    self.refresher.tintColor = UIColor.red
//    self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
//    self.collectionView!.addSubview(refresher)
//}
//
//@objc func loadData() {
//   self.collectionView!.refreshControl.beginRefreshing()
//   //code to execute during refresher
//       .
//       .
//       .
//   stopRefresher()         //Call this to stop refresher
// }
//
//func stopRefresher() {
//   self.collectionView!.refreshControl.endRefreshing()
// }
//
//
//extension YourViewController: UISearchBarDelegate {
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchActive = true
//        self.searchBar.showsCancelButton = true
//        self.collectionView.reloadData()
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        self.searchBar.text = ""
//        self.filtered = []
//        searchActive = false
//        self.searchBar.showsCancelButton = false
//        self.searchBar.endEditing(true)
//        self.dismiss(animated: true, completion: nil)
//        self.collectionView.reloadData()
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text! == " "  {
//            filtered = exercises
//            collectionView.reloadData()
//        } else {
//
//        filtered = exercises.filter({ (item) -> Bool in
//
//            return (item.exerciseNameLabel?.localizedCaseInsensitiveContains(String(searchBar.text!)))!
//
//            })
//
//        collectionView.reloadData()
//        }
//
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        collectionView.reloadData()
//    }
//
//}
