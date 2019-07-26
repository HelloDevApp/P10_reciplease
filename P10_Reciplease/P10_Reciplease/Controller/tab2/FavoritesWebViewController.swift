//
//  FavoritesWebViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 28/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit
import WebKit

class FavoritesWebViewController: UIViewController, WKNavigationDelegate {
    
    var url: URL?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURLDirections(url: url)
        webView.navigationDelegate = self
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
    
    // only for print
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("loading the web page...")
    }
    
    // only for print
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("web page finished loading!")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("error when loading the web page")
        presentAlert(titleAlert: .error, messageAlert: .noInternetConnection, actionTitle: .ok) { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
