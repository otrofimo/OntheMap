//
//  UdacityConvenience.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/5/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

extension UdacityClient {

    // Auth 1 -> username/password sent to udacity on success just show next controller

    func loginWith(username:String, password: String, completionHandler: (success: Bool, errorString: String) -> Void) {

        let authBody = ["udacity" : ["username": username, "password": password]]

        taskForPOSTMethod(UdacityClient.Methods.Session, jsonBody: authBody) { (JSONResults, error) in
            if let error = error {
                completionHandler(success: false, errorString: "\(error)")
            }

            guard let _ = JSONResults else {
                completionHandler(success: false, errorString: "\(error)")
                return
            }

            if let account = JSONResults[UdacityClient.JSONResponseKeys.Account] as? [String : AnyObject] {
                if account[UdacityClient.JSONResponseKeys.Registered] as? Bool == true {
                    completionHandler(success: true, errorString: "")
                } else {
                    completionHandler(success: false, errorString: "Udacity was not able to process your request")
                }
            } else {
                completionHandler(success: false, errorString: "Error parsing login response json")
            }
        }
    }

    // Auth 2 ->
    // 1) Ask the user to sign in
    // 2) Get session id and send to udacity

    func loginWith(fbBody: [String:AnyObject], completionHandler: (success: Bool, errorString: String)-> Void) {

        taskForPOSTMethod(UdacityClient.Methods.Session, jsonBody: fbBody) { (JSONResults, error) in

            if let error = error {
                completionHandler(success: false, errorString: "\(error)")
            }

            guard let _ = JSONResults else {
                completionHandler(success: false, errorString: "\(error)")
                return
            }

            if let _ = JSONResults[UdacityClient.JSONResponseKeys.Registered]  {
                completionHandler(success: true, errorString: "")
            }
        }
    }

    func deleteUdacitySession(completionHandler: (success: Bool, errorString: String) -> Void) {
        taskForDeleteMethod(UdacityClient.Methods.Session) { (JSONResults, error) -> Void in
            if let error = error {
                completionHandler(success: false, errorString: "\(error)")
            }

            guard let _ = JSONResults else {
                completionHandler(success: false, errorString: "\(error)")
                return
            }

            if let account = JSONResults[UdacityClient.JSONResponseKeys.Account] as? [String : AnyObject] {
                if account[UdacityClient.JSONResponseKeys.Registered] as? Bool == true {
                    completionHandler(success: true, errorString: "")
                } else {
                    completionHandler(success: false, errorString: "Udacity was not able to process your request")
                }
            } else {
                completionHandler(success: false, errorString: "Error parsing login response json")
            }

        }
    }

    func getUser(userId: Int) {

    }

    func deleteSessionWithFacebook() {
        
    }
}