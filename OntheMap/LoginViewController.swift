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

        // If the fb access token exists or you have a udaacity session already load mapViewController
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

        guard let username = usernameField.text, password = passwordField.text
            where usernameField.text != "" && passwordField.text != ""
        else {
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

        UdacityClient.sharedInstance.loginWith(username, password: password) { (success, results, errorString) in

            if errorString != "" || !success {
                let alertVC = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertVC.addAction(cancelAction)
                self.presentViewController(alertVC, animated: true, completion: nil)
                return
            }

            guard let account = results[UdacityClient.JSONResponseKeys.Account] as? [String: AnyObject] else {
                print("Result did not contain field \(UdacityClient.JSONResponseKeys.Account)")
                return
            }

            guard let userId = account[UdacityClient.JSONResponseKeys.Key] as? String else {
                print("Account did not contain field \(UdacityClient.JSONResponseKeys.Key)")
                return
            }

            self.appDelegate?.userID = userId

            self.getUserData(userId) { finished in
                if finished {
                    dispatch_async(dispatch_get_main_queue(), {
                        loginVC.presentMapViewController()
                    })
                }
            }
        }
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        let loginVC = self

        if let error = error {
            print("Error logging in : \(error)")
            return
        }

        if result.isCancelled {
            print("Error logging in: request is cancelled")
            return
        }

        guard let accessToken = result.token else {
            print("Result does not contain an access token")
            return
        }

        let fbBody = [UdacityClient.Parameters.FacebookMobile: [UdacityClient.Parameters.FacebookAccessToken: accessToken.tokenString]]

        UdacityClient.sharedInstance.loginWith(fbBody) { success, results, errorString in

            if errorString != "" || !success {
                let alertVC = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertVC.addAction(cancelAction)
                self.presentViewController(alertVC, animated: true, completion: nil)
                return
            }

            guard let account = results[UdacityClient.JSONResponseKeys.Account] as? [String: AnyObject] else {
                print("Result did not contain field \(UdacityClient.JSONResponseKeys.Account)")
                return
            }

            guard let userId = account[UdacityClient.JSONResponseKeys.Key] as? String else {
                print("Account did not contain field \(UdacityClient.JSONResponseKeys.Key)")
                return
            }

            self.appDelegate?.userID = userId

            self.getUserData(userId) { finished in
                if finished {
                    dispatch_async(dispatch_get_main_queue(), {
                        loginVC.presentMapViewController()
                    })
                }
            }
        }
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        // Handled by the logout button below
        print("user logged out")
    }

    func logout(sender: UIBarButtonItem) {

        // if facebook login -> logout of facebook session
        if let _ = FBSDKAccessToken.currentAccessToken() {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        } else {
            // if udacity login -> logout of udacity
            UdacityClient.sharedInstance.deleteUdacitySession { success, errorString in
                guard errorString == "" else {
                    print("Error logging out of udacity: \(errorString)")
                    return
                }
            }
        }

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

    func getUserData(userId: String, completionHandler: (Bool-> Void)) {
        UdacityClient.sharedInstance.getUserData(userId) { success, results, errorString in

            guard errorString != "" || success else {
                print("Could not get user data : \(errorString)")
                return
            }

            guard let user = results[UdacityClient.JSONResponseKeys.User] as? [String : AnyObject] else {
                print("Error: Request did not return user information")
                return
            }

            if let firstName = user[UdacityClient.JSONResponseKeys.FirstName] as? String,
                lastName = user[UdacityClient.JSONResponseKeys.LastName] as? String {
                    self.appDelegate?.userFirstName = firstName
                    self.appDelegate?.userLastName  = lastName

                    completionHandler(true)
            }
        }
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

