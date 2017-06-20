//
//  TableViewController.swift
//  github_incremental_search
//
//  Created by Yuqing Guan on 2017/06/19.
//  Copyright © 2017 Yuqing Guan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let urlString = "https://api.github.com/search/users?q=tom+repos:%3E42+followers:%3E1000"
    var idArray = [String]()
    var avatarURLArray = [String]()
    var addressArray = [String]()
//    var data_array = ["A", "B", "C", "D", "E", "F"]
//    var filteredArray = [String]()
//    var searchController = UISearchController()
//    var resultsController = UITableViewController()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadJsonWithURL()
        
//        searchController = UISearchController(searchResultsController: resultsController)
//        tableView.tableHeaderView = searchController.searchBar
//        searchController.searchResultsUpdater = self
//        
//        resultsController.tableView.delegate = self
//        resultsController.tableView.dataSource = self
        
        
    }
    
//    func updateSearchResults(for searchController: UISearchController) {
//        filteredArray = data_array.filter({ (array:String) -> Bool in
//            if array.contains(searchController.searchBar.text!){
//                return true
//            }
//            else{
//                return false
//            }
//        })
//        resultsController.tableView.reloadData()
//    }

    func downloadJsonWithURL(){
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                if let userArray = jsonObj!.value(forKey: "items") as? NSArray{
                    for user in userArray{
                        if let userDict = user as? NSDictionary{
                            if let loginID = userDict.value(forKey: "login"){
                                self.idArray.append(loginID as! String)
                                self.addressArray.append("https://github.com/\(loginID as! String)")
                            }
                            if let avatar = userDict.value(forKey: "avatar_url"){
                                self.avatarURLArray.append(avatar as! String)
                            }
                            
                            OperationQueue.main.addOperation({
                                self.tableView.reloadData()
                            })
                        }
                    }
                }
            }
        }).resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == resultsController.tableView{
//            return filteredArray.count
//        }
//        else{
//            return data_array.count
//        }
        return idArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
//        if tableView == resultsController.tableView{
//            cell.textLabel?.text = filteredArray[indexPath.row]
//        }
//        else{
//            cell.textLabel?.text = data_array[indexPath.row]
//        }
//        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        cell.idLabel.text = idArray[indexPath.row]
        cell.addressLabel.text = addressArray[indexPath.row]
        
        let avatarURL = NSURL(string: avatarURLArray[indexPath.row])
        let data = NSData(contentsOf: (avatarURL as URL?)!)
        cell.avatarView.image = UIImage(data: data! as Data)
        return cell
    }
}
