//
//  ViewController.swift
//  github_incremental_search
//
//  Created by Yuqing Guan on 2017/06/20.
//  Copyright © 2017 Yuqing Guan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    var searchURL = String()
    var idArray = [String]()
    var repoNameArray = [String]()
    var avatarURLArray = [String]()
    var starArray = [Int]()
    var forkArray = [Int]()
    var languageArray = [String]()
    var repoURLArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadJsonWithURL()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let webView = segue.destination as! WebViewController
        webView.requestURLString = self.repoURLArray[indexPath!]
    }
    
    func downloadJsonWithURL(){
        let url = NSURL(string: self.searchURL)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                if let userArray = jsonObj!.value(forKey: "items") as? NSArray{
                    //reset
                    self.idArray = [String]()
                    self.avatarURLArray = [String]()
                    self.repoNameArray = [String]()
                    self.repoURLArray = [String]()
                    self.starArray = [Int]()
                    self.forkArray = [Int]()
                    self.languageArray = [String]()
                    var count = 0
                    
                    for user in userArray{
                        if let userDict = user as? NSDictionary{
                            if let owner = userDict.value(forKey: "owner"){
                                if let ownerDict = owner as? NSDictionary{
                                    //user_id
                                    if let loginID = ownerDict.value(forKey: "login"){
                                        self.idArray.append(loginID as! String)
                                    }
                                    //user avatar
                                    if let avatar = ownerDict.value(forKey: "avatar_url"){
                                        self.avatarURLArray.append(avatar as! String)
                                    }
                                }
                            }
                            //repo name
                            if let repoName = userDict.value(forKey: "name"){
                                self.repoNameArray.append(repoName as! String)
                            }
                            //star
                            if let star = userDict.value(forKey: "stargazers_count"){
                                self.starArray.append(star as! Int)
                            }
                            //fork
                            if let fork = userDict.value(forKey: "forks_count"){
                                self.forkArray.append(fork as! Int)
                            }
                            //language
                            if let language = userDict.value(forKey: "language"){
                                self.languageArray.append(language as? String ?? "unkonwn")
                            }
                            //repo url
                            if let repoURL = userDict.value(forKey: "html_url"){
                                self.repoURLArray.append(repoURL as! String)
                            }
                            OperationQueue.main.addOperation({
                                self.tableView.reloadData()
                            })
                        }
                        count += 1
                        if count >= 30{
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
        cell.idLabel.text = self.idArray[indexPath.row]
        cell.repoNameLabel.text = self.repoNameArray[indexPath.row]
        cell.starLabel.text = String(self.starArray[indexPath.row])
        cell.forkLabel.text = String(self.forkArray[indexPath.row])
        cell.languageLabel.text = self.languageArray[indexPath.row]
        
        let avatarURL = NSURL(string: self.avatarURLArray[indexPath.row])
        let data = NSData(contentsOf: (avatarURL as URL?)!)
        cell.avatarView.image = UIImage(data: data! as Data)
        return cell
    }
}










