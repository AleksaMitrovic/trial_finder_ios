//
//  Message.swift
//  Trial Finder
//
//  Created by Milan Garg on 12/22/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import Foundation
class Message
{
    var senderId:String
    var displayName:String
    var message:String
    
    init(senderId:String, displayName:String, message:String) {
        self.senderId = senderId
        self.displayName = displayName
        self.message = message
    }
}
