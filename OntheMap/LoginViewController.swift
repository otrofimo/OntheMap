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

    let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate

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


    // TODO : For the love of god refactor with guard statements
    @IBAction func login(sender: AnyObject) {
        let loginVC = self
        if usernameField.text != "" && passwordField.text != "" {
            UdacityClient.sharedInstance.loginWith(usernameField.text!, password: passwordField.text!) { (success, results, errorString) in

                if errorString != "" {
                    let alertVC = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alertVC.addAction(cancelAction)
                    self.presentViewController(alertVC, animated: true, completion: nil)
                    return
                } else {
                    if success {
                        if let account = results[UdacityClient.JSONResponseKeys.Account] as? [String: AnyObject] {

                            guard let userId = account[UdacityClient.JSONResponseKeys.Key] as? String else {
                                print("User id is not present in response")
                                return
                            }

                            self.appDelegate?.userID = userId

                            UdacityClient.sharedInstance.getUserData(userId) { success, results, errorString in
                                guard success else {
                                    print(errorString)
                                    return
                                }
                                guard let user = results[UdacityClient.JSONResponseKeys.User] as? [String : AnyObject] else {
                                    print("Error: Request did not return user information")
                                    return
                                }

                                print("User is \(user)")

                                self.appDelegate?.userFirstName = user[UdacityClient.JSONResponseKeys.FirstName] as? String
                                self.appDelegate?.userLastName  = user[UdacityClient.JSONResponseKeys.LastName] as? String

                                // create navigationController and attach MapTableViewController with result attached as map pins
                                dispatch_async(dispatch_get_main_queue(), {
                                    loginVC.presentMapViewController()
                                })
                            }
                        }
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


    //TODO : For the love of god refactor with guard statements
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        let loginVC = self

        if let error = error {
            print("\(error)")
        } else if result.isCancelled {
            print("request cancelled")
        } else {
            if let accessToken = result.token {
                let fbBody = [UdacityClient.Parameters.FacebookMobile: [UdacityClient.Parameters.FacebookAccessToken: accessToken.tokenString]]
                UdacityClient.sharedInstance.loginWith(fbBody) { success, results, errorString in
                    if errorString != "" {
                        let alertVC = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alertVC.addAction(cancelAction)
                        self.presentViewController(alertVC, animated: true, completion: nil)
                        return
                    } else {
                        if success {
                            if let account = results[UdacityClient.JSONResponseKeys.Account] as? [String: AnyObject] {

                                if let userId = account[UdacityClient.JSONResponseKeys.Key] as? String {
                                    self.appDelegate?.userID = userId
                                    UdacityClient.sharedInstance.getUserData(userId) { success, results, errorString in
                                        guard success else {
                                            print(errorString)
                                            return
                                        }
                                        guard let user = results[UdacityClient.JSONResponseKeys.User] as? [String : AnyObject] else {
                                            print("Error: Request did not return user information")
                                            return
                                        }
                                        self.appDelegate?.userFirstName = user[UdacityClient.JSONResponseKeys.FirstName] as? String
                                        self.appDelegate?.userLastName  = user[UdacityClient.JSONResponseKeys.LastName] as? String

                                        dispatch_async(dispatch_get_main_queue(), {
                                            loginVC.presentMapViewController()
                                        })
                                    }
                                } else { print("could not find userId in results")}
                            } else {print ("could not find account key in results") }
                        } else { print("login unsuccessful")}
                    }
                }
            }
        }
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        // Handled in logout button below
        print("user logged out")
    }

    func logout(sender: UIBarButtonItem) {

        // if facebook login -> logout of facebook session
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()

        // TODO : if udacity login -> logout of udacity
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

    // Question? : You have both segue transitions and just manual pushing, do you need both?
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SignUpForUdacity" {
            let navVC = segue.destinationViewController as! UINavigationController
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "dismissController:")
            navVC.viewControllers.first!.navigationItem.leftBarButtonItem = cancelButton
        }
    }

    // TODO : Is this necessary
    func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
}

