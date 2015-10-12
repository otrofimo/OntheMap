//
//  UdacityConvenience.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/5/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import Foundation

extension UdacityClient {
    func loginWith(username:String, password: String, completionHandler: (success: Bool, errorString: String) -> Void) {

        let authBody = ["udacity" : ["username": username, "password": password]]

        taskForPOSTMethod(UdacityClient.Methods.Session, jsonBody: authBody) { (results, error) in
            if let error = error {
                completionHandler(success: false, errorString: "\(error)")
            }

            if (results[UdacityClient.JSONResponseKeys.Registered] as! Bool == true)  {
                completionHandler(success: true, errorString: "")
            } else {
                completionHandler(success: false, errorString: "Udacity was not able to process your request")
            }
        }
    }

    func loginWith(fbBody: [String:AnyObject], completionHandler: (success: Bool, errorString: String)-> Void) {
        taskForPOSTMethod(UdacityClient.Methods.Session, jsonBody: fbBody) { (results, error) in
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }

            if (results[UdacityClient.JSONResponseKeys.Registered] != nil)  {
                completionHandler(success: true, errorString: "")
            }
        }
    }

    func deleteSession() {

    }

    func getUser(userId: Int) {

    }

    func createSessionWithFacebook() {

    }

    func deleteSessionWithFacebook() {
        
    }
}