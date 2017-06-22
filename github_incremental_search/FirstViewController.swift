//
//  FirstViewController.swift
//  github_incremental_search
//
//  Created by Yuqing Guan on 2017/06/22.
//  Copyright © 2017 Yuqing Guan. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    var searchURL = String()
    var repoNameArray = [String]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let resultView = segue.destination as! ViewController
        resultView.searchURL = "https://api.github.com/search/repositories?q=\(repoNameArray[indexPath!])"
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keyword = searchText.replacingOccurrences(of: " ", with: "+")
        self.searchURL = "https://api.github.com/search/repositories?q=\(keyword)"
        self.downloadJsonWithURL()
    }
    
    func downloadJsonWithURL(){
        let url = NSURL(string: self.searchURL)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                if let userArray = jsonObj!.value(forKey: "items") as? NSArray{
                    //reset
                    self.repoNameArray = []
                    
                    for user in userArray{
                        if let userDict = user as? NSDictionary{
                            //repo name
                            if let repoName = userDict.value(forKey: "name"){
                                self.repoNameArray.append(repoName as! String)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.repoNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fcell") as! FirstTableViewCell
        cell.keywordLabel.text = self.repoNameArray[indexPath.row]
        return cell
    }
}






