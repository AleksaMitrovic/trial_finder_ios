//
//  StoreDataObject.swift
//  Trial Finder
//
//  Created by Mobytelab on 5/13/17.
//  Copyright © 2017 Iran Mateu. All rights reserved.
//

import Foundation

class StoreDataObject: NSObject, NSCoding {
    let siteListKey: String
    let text: String
    let timeStamp: String
    let senderId: String
    
    init(siteListKey: String, text: String, timeStamp: String, senderId: String) {
        self.siteListKey = siteListKey
        self.text = text
        self.timeStamp = timeStamp
        self.senderId = senderId
    }
    
    required init(coder decoder: NSCoder) {
        self.siteListKey = decoder.decodeObject(forKey: "siteListKey") as? String ?? ""
        self.text = decoder.decodeObject(forKey: "text") as? String ?? ""
        self.timeStamp = decoder.decodeObject(forKey: "timeStamp") as? String ?? ""
        self.senderId = decoder.decodeObject(forKey: "senderId") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.siteListKey, forKey: "siteListKey")
        coder.encode(self.text, forKey: "text")
        coder.encode(self.timeStamp, forKey: "timeStamp")
        coder.encode(self.senderId, forKey: "senderId")
    }
}
    
