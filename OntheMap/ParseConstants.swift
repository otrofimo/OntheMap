//
//  ParseConstants.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/5/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import Foundation

extension ParseClient {
    struct Constants {
        // MARK: URLs
        static let BaseURLSecure : String = "https://api.parse.com/1/classes/"

        // MARK: API Keys
        static let ApiClientId : String = ParseClient.sharedInstance.valueForAPIKey("PARSE_API_CLIENT_ID")
        static let RestApiKey : String = ParseClient.sharedInstance.valueForAPIKey("PARSE_REST_API_KEY")
    }

    struct HTTPBodyKeys {
        static let ApiClientId : String = "X-Parse-Application-Id"
        static let RestApiKey  : String = "X-Parse-REST-API-Key"
    }

    struct Methods {
        static let StudentLocations = "StudentLocation"
        static let PostStudentLocation = "StudentLocation/{id}"
    }

    struct URLkeys {
        static let StudentLocationID = "id"
    }

    struct OptionalKeys {
        static let limitKey : String = "limit"
        static let skipKey  : String = "skip"
        static let orderKey : String = "order"
        static let whereKey : String = "where"
    }

    struct JSONBodyKeys {
        static let uniqueKey : String = "uniqueKey"
        static let firstName : String = "firstName"
        static let lastName  : String = "lastName"
        static let mapString : String = "mapString"
        static let mediaURL  : String = "mediaURL"
        static let latitude  : String = "latitude"
        static let longitude : String = "longitude"
    }

    struct JSONResponseKeys {
        static let StudentLocationResult = "results"

        static let StudentLocationCreatedAt = "createdAt"
        static let StudentLocationFirstName = "firstName"
        static let StudentLocationLastName = "lastName"
        static let StudentLocationLatitude = "latitude"
        static let StudentLocationLongitude = "longitude"
        static let StudentLocationMapString = "mapString"
        static let StudentLocationMediaURL = "mediaURL"
        static let StudentLocationObjectID = "objectId"
        static let StudentLocationUniqueKey = "uniqueKey"
        static let StudentLocationUpdatedAt = "updatedAt"
    }

}