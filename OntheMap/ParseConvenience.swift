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

        let task = taskForGETMethod(Methods.StudentLocation, parameters: parameters) { JSONResult, error in
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                if let results = JSONResult[ParseClient.JSONResponseKeys.StudentLocationResults] as? [[String : AnyObject]] {

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

        ParseClient.sharedInstance.taskForPOSTMethod(ParseClient.Methods.StudentLocation, parameters: [:], jsonBody:studentLocation.properties) { (JSONResult, error) in
            if let error = error {
                completionHandler(result: false, error: error)
            } else {

                //  This should not have this much knowledge about the model! 
                //  Pass the response data into a completion handler to be handled by the view controller instead

                if JSONResult[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] != nil && JSONResult[ParseClient.JSONResponseKeys.StudentLocationObjectID] != nil {

                    studentLocation.properties[ParseClient.JSONResponseKeys.StudentLocationObjectID] = JSONResult[ParseClient.JSONResponseKeys.StudentLocationObjectID]

                    // Since the object is created the created and updated dates should be the same
                    studentLocation.properties[ParseClient.JSONResponseKeys.StudentLocationCreatedAt] = JSONResult[ParseClient.JSONResponseKeys.StudentLocationCreatedAt]
                    studentLocation.properties[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] = JSONResult[ParseClient.JSONResponseKeys.StudentLocationCreatedAt]

                    completionHandler(result: true, error: nil)
                }
            }
        }
    }

    func queryStudentLocation(parameters: [String : AnyObject], completionHandler: (result: [String: AnyObject]?, error: NSError?) -> Void) -> NSURLSessionDataTask {

        let task = ParseClient.sharedInstance.taskForGETMethod(ParseClient.Methods.StudentLocation, parameters: parameters) { (JSONResult, error) in
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

        let task = ParseClient.sharedInstance.taskForPOSTMethod(ParseClient.Methods.UpdateStudentLocation, parameters: parameters, jsonBody:studentLocation.properties) { (JSONResult, error) in
            if let error = error {
                completionHandler(result: false, error: error)
            } else {
                if let results = JSONResult[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] as? [String : AnyObject] {


                    //  This should not have this much knowledge about the model!
                    //  Pass the response data into a completion handler to be handled by the view controller instead

                    studentLocation.properties[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] = studentLocation.formatDatefromString(studentLocation.dateFormatFromAPI, string: (results[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] as? String)!)!

                    completionHandler(result: true, error: error)
                }
            }
        }
        return task
    }
}