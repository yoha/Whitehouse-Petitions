//
//  DetailViewController.swift
//  Whitehouse Petitions
//
//  Created by Yohannes Wijaya on 8/13/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    // MARK: - Stored Properties
    
    var webView: WKWebView!
    var detailItem: [String: String]!
    
    // MARK: - Methods Override
    
    override func loadView() {
        self.webView = WKWebView()
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard detailItem != nil else { return }
        
        if let body = detailItem["body"] {
            var html = "<html>"
            html += "<head>"
            html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
            html += "<style> body { font-size: 150%; } </style>"
            html += "</head>"
            html += "<body>"
            html += body
            html += "</body>"
            html += "</html>"
            webView.loadHTMLString(html, baseURL: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

