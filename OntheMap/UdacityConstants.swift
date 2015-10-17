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
        static let BaseURLString = "https://www.udacity.com/"

        // MARK: API Keys
        static let FacebookAppID : String = ParseClient.sharedInstance.valueForAPIKey("FACEBOOK_APP_ID")
    }

    struct Methods {
        static let API     = "api/"
        static let Session = "session"
        static let Users   = "users/{id}"
        static let SignUpURLString = "account/auth#!/signup"
        static let SignUpCompleteString = "me"

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
        // First level
        static let Account      = "account"
        static let Session      = "session"
        static let UpdatedAt    = "updatedAt"
        
        // Second level
        static let Registered   = "registered"
        static let ID           = "id"
        static let Expiration   = "expiration"
        static let Key          = "key"

    }

}