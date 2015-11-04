//
//  StudentLocation.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/4/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import Foundation

struct StudentLocation {

    // MARK: Properties
    var properties : [String: AnyObject]! = [:]
    let dateFormatter = NSDateFormatter()
    let dateFormatFromAPI = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"

    init(dictionary: [String : AnyObject]) {

        properties[ParseClient.JSONResponseKeys.StudentLocationFirstName]   = dictionary[ParseClient.JSONResponseKeys.StudentLocationFirstName] as? String
        properties[ParseClient.JSONResponseKeys.StudentLocationLastName]    = dictionary[ParseClient.JSONResponseKeys.StudentLocationLastName] as? String
        properties[ParseClient.JSONResponseKeys.StudentLocationLatitude]    = dictionary[ParseClient.JSONResponseKeys.StudentLocationLatitude] as? Float
        properties[ParseClient.JSONResponseKeys.StudentLocationLongitude]   = dictionary[ParseClient.JSONResponseKeys.StudentLocationLongitude] as? Float
        properties[ParseClient.JSONResponseKeys.StudentLocationMapString]   = dictionary[ParseClient.JSONResponseKeys.StudentLocationMapString] as? String
        properties[ParseClient.JSONResponseKeys.StudentLocationMediaURL]    = dictionary[ParseClient.JSONResponseKeys.StudentLocationMediaURL] as? String
        properties[ParseClient.JSONResponseKeys.StudentLocationObjectID]    = dictionary[ParseClient.JSONResponseKeys.StudentLocationObjectID] as? String
        properties[ParseClient.JSONResponseKeys.StudentLocationUniqueKey]   = dictionary[ParseClient.JSONResponseKeys.StudentLocationUniqueKey] as? String


        if let createdAtString = dictionary[ParseClient.JSONResponseKeys.StudentLocationCreatedAt] as? String {
            if let createdDate = formatDatefromString(dateFormatFromAPI, string: createdAtString) {
                self.properties[ParseClient.JSONResponseKeys.StudentLocationCreatedAt] = createdDate
            }
        }

        if let updatedAtString = dictionary[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] as? String {
            if let updatedDate = formatDatefromString(dateFormatFromAPI, string: updatedAtString) {
                self.properties[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] = updatedDate
            }
        }
    }

    static func StudentLocationsfromResults(results:[[String:AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()

        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }

        return studentLocations
    }

    func formatDatefromString(format: String, string: String) -> NSDate? {
        self.dateFormatter.dateFormat = format
        guard let date = dateFormatter.dateFromString(string) else {
            print("Error parsing date")
            return nil
        }
        return date
    }
}