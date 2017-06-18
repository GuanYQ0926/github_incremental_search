//
//  TableViewController.swift
//  github_incremental_search
//
//  Created by Yuqing Guan on 2017/06/19.
//  Copyright © 2017 Yuqing Guan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchResultsUpdating {

    var data_array = ["A", "B", "C", "D", "E", "F"]
    var filteredArray = [String]()
    var searchController = UISearchController()
    var resultsController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: resultsController)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        
        resultsController.tableView.delegate = self
        resultsController.tableView.dataSource = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredArray = data_array.filter({ (array:String) -> Bool in
            if array.contains(searchController.searchBar.text!){
                return true
            }
            else{
                return false
            }
        })
        resultsController.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == resultsController.tableView{
            return filteredArray.count
        }
        else{
            return data_array.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        if tableView == resultsController.tableView{
            cell.textLabel?.text = filteredArray[indexPath.row]
        }
        else{
            cell.textLabel?.text = data_array[indexPath.row]
        }
        return cell
    }
}
