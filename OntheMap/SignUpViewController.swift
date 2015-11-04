//
//  SignUpViewController.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/14/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import UIKit
import WebKit

class SignUpViewController: WebViewController {

    override func viewDidLoad() {
        startURLString = UdacityClient.Constants.BaseURLString + UdacityClient.Methods.SignUpURLString
        finishURLString = UdacityClient.Constants.BaseURLString + UdacityClient.Methods.SignUpCompleteString
        completionTitle = "Congrats"
        completionMessage = "you successfully signed up for Udacity"

        super.viewDidLoad()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}