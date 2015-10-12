//
//  ParseConvenience.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/5/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import Foundation

extension ParseClient {

    func getStudentLocations(parameters: [String: String], completionHandler: (result: [StudentLocation]?, error: NSError?) -> Void) -> NSURLSessionDataTask {

        let task = taskForGETMethod(Methods.StudentLocations, parameters: parameters) { JSONResult, error in
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                if let results = JSONResult[ParseClient.JSONResponseKeys.StudentLocationResult] as? [[String : AnyObject]] {

                    let locations = StudentLocation.StudentLocationsfromResults(results)
                    completionHandler(result: locations, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getMoviesForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMoviesForSearchString"]))
                }
            }
        }
        return task
    }

    func postStudentLocation(inout studentLocation: StudentLocation, completionHandler: (result: Bool?, error: NSError?) -> Void) {
        ParseClient.sharedInstance.taskForPOSTMethod(ParseClient.Methods.PostStudentLocation, parameters: [:], jsonBody:studentLocation.properties) { (JSONResult, error) in
            if let error = error {
                completionHandler(result: false, error: error)
            } else {
                if JSONResult[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] != nil && JSONResult[ParseClient.JSONResponseKeys.StudentLocationObjectID] != nil {
                    studentLocation.properties[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] = JSONResult[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt]
                    completionHandler(result: true, error: nil)
                }
            }
        }
    }

    func queryStudentLocation(parameters: [String : AnyObject], completionHandler: (result: [String: AnyObject]?, error: NSError?) -> Void) -> NSURLSessionDataTask {

        let task = ParseClient.sharedInstance.taskForGETMethod(ParseClient.Methods.StudentLocations, parameters: parameters) { (JSONResult, error) in
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                if let results = JSONResult[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] as? [String : AnyObject] {
                    completionHandler(result: results, error: error)
                }
            }
        }

        return task
    }

    func updateStudentLocation(inout studentLocation: StudentLocation, parameters:[String:AnyObject], completionHandler: (result: Bool?, error: NSError?) -> Void) -> NSURLSessionDataTask {

        let task = ParseClient.sharedInstance.taskForPOSTMethod(ParseClient.Methods.PostStudentLocation, parameters: parameters, jsonBody:studentLocation.properties) { (JSONResult, error) in
            if let error = error {
                completionHandler(result: false, error: error)
            } else {
                if let results = JSONResult[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] as? [String : AnyObject] {
                    // continue down into the completion handler
                    studentLocation.properties[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] = studentLocation.formatDatefromString(studentLocation.dateFormatFromAPI, string: (results[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] as? String)!)!

                    completionHandler(result: true, error: error)
                }
            }
        }
        return task
    }
}