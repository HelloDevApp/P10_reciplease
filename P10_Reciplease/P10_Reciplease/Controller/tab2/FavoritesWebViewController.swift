//
//  FavoritesWebViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 28/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit
import WebKit

class FavoritesWebViewController: UIViewController {
    
    var url: URL?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURLDirections(url: url)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButton() {
        webView.reload()
    }
    
    func loadURLDirections(url: URL?) {
        if let urlDirection = url {
            let urlDirectionsRequest = URLRequest(url: urlDirection)
            webView.load(urlDirectionsRequest)
        }
    }
}
