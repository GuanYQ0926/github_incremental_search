//
//  WebViewController.swift
//  github_incremental_search
//
//  Created by Yuqing Guan on 2017/06/21.
//  Copyright © 2017 Yuqing Guan. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var requestURLString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let requestURL = URL(string: requestURLString)
        let request = URLRequest(url: requestURL!)
        webView.loadRequest(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
