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

    func loginWith(username:String, password: String, completionHandler: (success: Bool, results: [String : AnyObject], errorString: String) -> Void) {

        let authBody = ["udacity" : ["username": username, "password": password]]

        taskForPOSTMethod(UdacityClient.Methods.Session, jsonBody: authBody) { (JSONResults, error) in
            if let error = error {
                completionHandler(success: false, results: [:], errorString: "\(error.localizedDescription)")
            }

            guard let JSONResults = JSONResults as? [String: AnyObject] else {
                completionHandler(success: false, results: [:], errorString: "\(error?.localizedDescription)")
                return
            }

            if let account = JSONResults[UdacityClient.JSONResponseKeys.Account] as? [String : AnyObject]
                where account[UdacityClient.JSONResponseKeys.Registered] as? Bool == true {
                    completionHandler(success: true, results: JSONResults , errorString: "")
            } else {
                completionHandler(success: false, results: JSONResults, errorString: "Error with Login")
            }
        }
    }

    // Auth 2 ->
    // 1) Ask the user to sign in
    // 2) Get session id and send to udacity

    func loginWith(fbBody: [String:AnyObject], completionHandler: (success: Bool, results: [String : AnyObject], errorString: String)-> Void) {

        taskForPOSTMethod(UdacityClient.Methods.Session, jsonBody: fbBody) { (JSONResults, error) in

            if let error = error {
                completionHandler(success: false, results: [:], errorString: error.localizedDescription)
            }

            guard let JSONResults = JSONResults as? [String: AnyObject] else {
                completionHandler(success: false, results: [:], errorString: "\(error?.localizedDescription)")
                return
            }

            if let account = JSONResults[UdacityClient.JSONResponseKeys.Account] as? [String : AnyObject]
                where account[UdacityClient.JSONResponseKeys.Registered] as? Bool == true {
                    completionHandler(success: true, results: JSONResults , errorString: "")
            }
        }
    }

    func deleteUdacitySession(completionHandler: (success: Bool, errorString: String) -> Void) {
        taskForDeleteMethod(UdacityClient.Methods.Session) { (JSONResults, error) -> Void in
            if let error = error {
                completionHandler(success: false, errorString: "\(error.localizedDescription)")
            }

            guard let _ = JSONResults else {
                completionHandler(success: false, errorString: "\(error?.localizedDescription)")
                return
            }

            if let session = JSONResults[UdacityClient.JSONResponseKeys.Session] as? [String : AnyObject] {
                if (session[UdacityClient.JSONResponseKeys.Expiration] as? String != nil) {
                    completionHandler(success: true, errorString: "")
                } else {
                    completionHandler(success: false, errorString: "Udacity was not able to process your request")
                }
            } else {
                completionHandler(success: false, errorString: "Error parsing login response json")
            }
        }
    }

    func getUserData(userId: String, completionHandler: (success: Bool, result: [String : AnyObject], errorString: String)-> Void) {

        guard let method = UdacityClient.subtituteKeyInMethod(Methods.Users, key: "id", value: userId) else {
            print("URL method string is not correctly created")
            return
        }

        taskForGETMethod(method, parameters: [:]) { (results, error) -> Void in
            if let error = error, _ = results {
                completionHandler(success: false, result: [:], errorString: "\(error.localizedDescription)")
            }

            if let JSONresults = results as? [String : AnyObject] {
                completionHandler(success: true, result: JSONresults, errorString: "")
            }
        }
    }
}