//
//  ViewController.swift
//  github_incremental_search
//
//  Created by Yuqing Guan on 2017/06/20.
//  Copyright © 2017 Yuqing Guan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    var searchURL = String() //"https://api.github.com/search/users?q=tom+repos:%3E42+followers:%3E1000"
    var idArray = [String]()
    var avatarURLArray = [String]()
    var addressArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.downloadJsonWithURL()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchURL = "https://api.github.com/search/users?q=\(searchText)"
        self.idArray = [String]()
        self.avatarURLArray = [String]()
        self.addressArray = [String]()
        self.downloadJsonWithURL()
    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        //let keyword = String(describing: searchBar.text)
//        let keyword = searchBar.text
//        self.searchURL = "https://api.github.com/search/users?q=\(keyword ?? "a")"
//        print(searchURL)
//        self.idArray = [String]()
//        self.avatarURLArray = [String]()
//        self.addressArray = [String]()
//        self.downloadJsonWithURL()
//    }
    

    func downloadJsonWithURL(){
        let url = NSURL(string: self.searchURL)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                if let userArray = jsonObj!.value(forKey: "items") as? NSArray{
                    var count = 0
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
                        count += 1
                        if count == 10{
                            break
                        }
                    }
                }
            }
        }).resume()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return idArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        cell.idLabel.text = idArray[indexPath.row]
        cell.addressLabel.text = addressArray[indexPath.row]
        
        let avatarURL = NSURL(string: avatarURLArray[indexPath.row])
        let data = NSData(contentsOf: (avatarURL as URL?)!)
        cell.avatarView.image = UIImage(data: data! as Data)
        return cell
    }
}










