//
//  UdacityConstants.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/5/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import Foundation

extension UdacityClient {
    struct Constants {
        // MARK: URL String
        static let BaseURLString = "https://www.udacity.com/api/"

        // MARK: API Keys
        static let FacebookAppID : String = ParseClient.sharedInstance.valueForAPIKey("FACEBOOK_APP_ID")
    }

    struct Methods {
        static let Session = "session"
        static let Users   = "users/{id}"
    }

    struct Parameters {
        static let FacebookMobile       = "facebook_mobile"
        static let Udacity              = "udacity"
        static let FacebookAccessToken  = "access_token"
    }

    struct JSONBodyKeys {
        static let Username = "username"
        static let Password = "password"
    }

    struct JSONResponseKeys {
        static let Registered = "registered"
    }

}