//
//  ViewController.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/3/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        if usernameField.text != "" && passwordField.text != "" {
            UdacityClient.sharedInstance.loginWith(usernameField.text!, password: passwordField.text!) { (success, errorString) in

                if errorString != "" {
                    let alertVC = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(alertVC, animated: true, completion: nil)
                    return
                } else {
                    if success {
                        // create navigationController and attach MapTableViewController with result attached as map pins

                        let navController = self.storyboard?.instantiateViewControllerWithIdentifier("NavController")
                        self.presentViewController(navController!, animated: true, completion: nil)
                    }
                }
            }
        } else {
            // popup notification that username / password is missing
        }
    }

}

