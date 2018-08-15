//
//  User.swift
//  Trial Finder
//
//  Created by Huynh Danh on 10/18/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import Foundation

class UserModel {
    
    var firstName: String!
    var lastName: String!
    var isMale: Bool!
    var birthdate: Date!
    var weight: Double!
    var height: Double!
    var language: String!
    
    init(dict: [String: AnyObject]) {
        self.firstName = dict["firstName"] as? String
        self.lastName = dict["lastName"] as? String
        self.isMale = dict["isMale"] as? Bool
        if let timestamp = dict["birthdate"] as? Double {
            self.birthdate = Date(timeIntervalSince1970: timestamp)
        }
        self.weight = dict["weight"] as? Double
        self.height = dict["height"] as? Double
        
        self.language = dict["language"] as? String
    }
}
