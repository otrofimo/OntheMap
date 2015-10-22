//
//  ViewController.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/3/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var facebookLogin: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let _ = FBSDKAccessToken.currentAccessToken() {
            dispatch_async(dispatch_get_main_queue(), {
                self.presentMapViewController()
            })
        }
    }

    override func viewWillAppear(animated: Bool) {
        // Because facebook deletes the login button and removes the delegate. Everytime this page appears need to reset the delegate. Its kinda dirty and maybe its better to do this manually instead of relying on this out of the box stuff
        self.facebookLogin.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        let loginVC = self
        if usernameField.text != "" && passwordField.text != "" {
            UdacityClient.sharedInstance.loginWith(usernameField.text!, password: passwordField.text!) { (success, errorString) in

                if errorString != "" {
                    let alertVC = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alertVC.addAction(cancelAction)
                    self.presentViewController(alertVC, animated: true, completion: nil)
                    return
                } else {
                    if success {
                        // create navigationController and attach MapTableViewController with result attached as map pins
                        dispatch_async(dispatch_get_main_queue(), {
                            loginVC.presentMapViewController()
                        })
                    }
                }
            }
        } else {
            // pop-up notification that username / password is missing
            var message = "Missing:\n "

            if usernameField.text == "" {message += "Username\n"}
            if passwordField.text == "" {message += "Password"}

            let alertVC = UIAlertController(title: "Login Credentials", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertVC.addAction(cancelAction)
            self.presentViewController(alertVC, animated: true, completion: nil)
            return
        }
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        let loginVC = self

        if let error = error {
            print("\(error)")
        } else if result.isCancelled {
            print("request cancelled")
        } else {
            if let accessToken = result.token {
                let fbBody = [UdacityClient.Parameters.FacebookMobile: [UdacityClient.Parameters.FacebookAccessToken: accessToken.tokenString]]
                UdacityClient.sharedInstance.loginWith(fbBody) { (success, errorString) in
                    if errorString != "" {
                        let alertVC = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alertVC.addAction(cancelAction)
                        self.presentViewController(alertVC, animated: true, completion: nil)
                        return
                    } else {
                        if success {
                            dispatch_async(dispatch_get_main_queue(), {
                                loginVC.presentMapViewController()
                            })
                        }
                    }
                }
            }
        }
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user logged out")
    }

    func logout(sender: UIBarButtonItem) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()

        // if udacity login -> logout of udacity
        // if facebook login -> logout of facebook session

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func presentMapViewController() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout:")

        let mapTabViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapTabViewController") as! MapTabViewController
        mapTabViewController.navigationItem.leftBarButtonItem = logoutButton

        let managerNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("ManagerNavigationController") as!
        UINavigationController
        managerNavigationController.setViewControllers([mapTabViewController], animated: true)

        self.presentViewController(managerNavigationController, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SignUpForUdacity" {
            let navVC = segue.destinationViewController as! UINavigationController
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "dismissController:")
            navVC.viewControllers.first!.navigationItem.leftBarButtonItem = cancelButton
        }
    }

    func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
}

