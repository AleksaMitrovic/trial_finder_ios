//
//  Site.swift
//  Trial Finder
//
//  Created by Huynh Danh on 10/17/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import Foundation
import CoreLocation

class Site {
    
    var id: String!
    var name: String!
    var logoUrl: String!
    var officeImageUrl: String!
    var address: String!
    var latitude: Double!
    var longitude: Double!
    var phoneNumber: String!
    var email: String!
    var zipCode: String!
    
    var distance: Double = 0.0
    
    init(id: String) {
        self.id = id
    }
    
    init(dict: [String: AnyObject]) {

        self.name = dict["siteName"] as? String
        self.logoUrl = dict["siteLogo"] as? String
        self.officeImageUrl = dict["siteOfficeImg"] as? String
        
        if let location = dict["location"] as? [String: AnyObject] {
            self.latitude = location["latitude"] as? Double
            self.longitude = location["longitude"] as? Double
            self.address = location["address"] as? String
        }
        
        self.phoneNumber = dict["phoneNumber"] as? String
        self.email = dict["email"] as? String
        updateLocation()
        self.zipCode = dict["zipCode"] as? String ?? ""
    }
    
    func updateLocation()  {
        if let lat = latitude, let lon = longitude, let userLocation = AppState.userLocation {
            distance = userLocation.distance(from: CLLocation(latitude: lat, longitude: lon))
        }
    }
}
