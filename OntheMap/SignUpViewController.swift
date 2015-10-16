//
//  SignUpViewController.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/14/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import UIKit
import WebKit

class SignUpViewController: UIViewController, WKNavigationDelegate {

    var webView : WKWebView

    required init!(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(webView)

        let url = NSURL(string: UdacityClient.Constants.SignUpURLString)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)

        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)

        view.addConstraints([height,width])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
