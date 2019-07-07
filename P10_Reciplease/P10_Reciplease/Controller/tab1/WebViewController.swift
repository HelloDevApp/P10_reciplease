//
//  WebViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 24/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var url: URL?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURLDirections(url: url)
        // Do any additional setup after loading the view.
    }
    deinit {
        print("deinit: WebViewVC")
    }
    
    @IBAction func actionCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionReloadButton(_ sender: UIButton) {
        webView.reload()
    }
    
    func loadURLDirections(url: URL?) {
        if let urlDirection = url {
            let urlDirectionsRequest = URLRequest(url: urlDirection)
            webView.load(urlDirectionsRequest)
        }
    }
}
