//
//  WebViewController.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/26/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView : WKWebView

    var startURLString = ""
    var finishURLString: String!

    var completionTitle: String!
    var completionMessage: String!

    required init!(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self

        // Fun times to get frame of view inside nav controller
        let navVC = self.navigationController
        let heightDifference = UIApplication.sharedApplication().statusBarFrame.height + (navVC?.navigationBar.frame.size.height)!
        let navBarOffsetFrame = CGRectOffset(navVC!.view.frame, CGFloat(0), heightDifference)

        webView.frame = navBarOffsetFrame

        view.addSubview(webView)

        print("loading url \(startURLString)")

        let url = NSURL(string: startURLString)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {

        // use guard instead
        if let _ = webView.URL?.absoluteString.rangeOfString(finishURLString)  {
            webView.removeFromSuperview()
            self.dismissViewControllerAnimated(true) {
                let alertVC = UIAlertController(title: self.completionTitle, message: self.completionMessage, preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertVC.addAction(cancelAction)
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(alertVC, animated: true, completion: nil)
                })
            }
        }
    }
}
