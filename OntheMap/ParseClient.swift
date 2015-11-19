//
//  ParseClient.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/5/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    // MARK: Properties

    static let sharedInstance = ParseClient()

    /* Shared session */
    var session: NSURLSession

    // MARK: Initializers

    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    // MARK: GET
    func taskForGETMethod(method:String, parameters: [String:AnyObject], completionHandler: (result: AnyObject!, error:NSError?) -> Void) -> NSURLSessionDataTask {

        let urlString = Constants.BaseURLSecure + method + ParseClient.escapedParameters(parameters)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.addValue(ParseClient.Constants.ApiClientId, forHTTPHeaderField: ParseClient.HTTPBodyKeys.ApiClientId)
        request.addValue(ParseClient.Constants.RestApiKey, forHTTPHeaderField: ParseClient.HTTPBodyKeys.RestApiKey)

        let task = session.dataTaskWithRequest(request) { (data, response, error) in

            /* GUARD: Was there an error? */
            if let error = error {
                print("There was an error with your request: \(error.localizedDescription)")
                let userInfo : [NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey :  NSLocalizedString("Request Failed", value: error.localizedDescription, comment: "")
                ]
                let error = NSError(domain: "FailedRequest", code: 400 , userInfo: userInfo)
                completionHandler(result: nil, error: error)
            }

            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")

                    let userInfo : [NSObject : AnyObject] = [
                        NSLocalizedDescriptionKey :  NSLocalizedString("Login Failed", value: "Please make sure you entered the correct credentials", comment: "")
                    ]
                    let error = NSError(domain: "FailedRequest", code: response.statusCode, userInfo: userInfo)
                    completionHandler(result: nil, error: error)

                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }

            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }

        task.resume()

        return task

    }

    // MARK: POST

    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

        let urlString = Constants.BaseURLSecure + method + ParseClient.escapedParameters(parameters)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.addValue(ParseClient.Constants.ApiClientId, forHTTPHeaderField: ParseClient.HTTPBodyKeys.ApiClientId)
        request.addValue(ParseClient.Constants.RestApiKey, forHTTPHeaderField: ParseClient.HTTPBodyKeys.RestApiKey)

        request.HTTPMethod = "POST"

        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }

        let task = session.dataTaskWithRequest(request) { (data, response, error) in

            /* GUARD: Was there an error? */
            if let error = error{
                print("There was an error with your request: \(error.localizedDescription)")
                let userInfo : [NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey :  NSLocalizedString("Request Failed", value: error.localizedDescription, comment: "")
                ]
                
                let error = NSError(domain: "Failed Request", code: 400 , userInfo: userInfo)
                completionHandler(result: nil, error: error)
            }

            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }

            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }

        task.resume()

        return task
    }

    // MARK: Helpers

    /* Helper: Given raw JSON, return Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {

        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }

        completionHandler(result: parsedResult, error: nil)
    }

    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {

        var urlVars = [String]()

        for (key, value) in parameters {

            /* Make sure that it is a string value */
            let stringValue = "\(value)"

            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())

            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]

        }

        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }

    func valueForAPIKey(keyname:String) -> String {
        let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType:"plist")
        let plist = NSDictionary(contentsOfFile:filePath!)

        let value:String = plist?.objectForKey(keyname) as! String
        return value
    }

}