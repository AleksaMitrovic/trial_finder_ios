//
//  Trial.swift
//  Trial Finder
//
//  Created by Iran Mateu on 10/12/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import Foundation
import CoreLocation

class Trial {
    
    private var _studyName: String!
    private var _conditionImageUrl: String!
    private var _studySponsor: String!
    private var _trialKey: String!
    var details: String!
    var site: Site!
    var date: Date!
    
    var studyName: String! {
        return _studyName
    }
    
    var conditionImageUrl: String {
        return _conditionImageUrl
    }
    
    var studySponsor: String {
        return _studySponsor
    }
    
    var trialKey: String {
        return _trialKey
    }
    
    init(studyName: String, studySponsor: String) {
        self._studyName = studyName
        self._conditionImageUrl = studyName
        self._studySponsor = studySponsor
    }
    
    init(trialKey: String, postData: Dictionary<String, AnyObject>) {
        self._trialKey = trialKey
        
        
        if let studyName = postData["studyName"] as? String {
            self._studyName = studyName
        }
        
        if let conditionImageUrl = postData["conditionIcon"] as? String {
            self._conditionImageUrl = conditionImageUrl
        }
        
        if let studySponsor = postData["studySponsor"] as? String {
            self._studySponsor = studySponsor
        }
        
        if let details = postData["details"] as? String {
            self.details = details
        }
        
        if let datePosted = postData["datePosted"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            self.date = dateFormatter.date(from: datePosted)
        }
        // Make sure the postedDate != nil
        if self.date == nil { self.date = Date() }
    }
}
