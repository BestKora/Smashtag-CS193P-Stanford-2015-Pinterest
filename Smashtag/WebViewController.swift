//
//  WebViewController.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/10/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: public API
    
    var url: NSURL?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        if let actualURL = url {
            let urlRequest = NSURLRequest(URL: actualURL)
            webView.scalesPageToFit = true
            
            webView.allowsInlineMediaPlayback = true
            
            webView.loadRequest(urlRequest)
        }
        
        // добавляем кнопку replay для возврата в Web View
        let backButton = UIBarButtonItem(barButtonSystemItem: .Reply,
                                                      target: self,
                                                      action: "actionGoBack:")
        if let button = navigationItem.rightBarButtonItem {
            navigationItem.rightBarButtonItems = [button,backButton]
        } else {
            navigationItem.rightBarButtonItem = backButton
        }
        
    }
    
    func actionGoBack(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    
    // MARK: - Web View Delegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        spinner.stopAnimating()
    }
    
    func webViewdidFailLoadWithError( error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        spinner.stopAnimating()
        print("проблемы с загрузкой web страницы!")
    }
    
}
