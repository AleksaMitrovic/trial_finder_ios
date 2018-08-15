//
//  SiteList.swift
//  Trial Finder
//
//  Created by Milan Garg on 12/18/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

internal class SiteList {
    internal var id: String
    internal var siteName: String
    internal var storeName: String
    internal var subj: String
    var lastMessage: String = ""
    var lastMessageTimeStamp: Date?
    var lastSenderId = ""
    var isNew: Bool = false
    var lastMessageOrderNumber = 0
    var isDeleted = false

    init(id: String, siteName: String, subj: String) {
        self.id = id
        self.siteName = siteName
        self.subj = subj
        self.storeName = ""
    }
    
    init(id: String, siteName: String, storeName: String, subj: String) {
        self.id = id
        self.siteName = siteName
        self.storeName = storeName
        self.subj = subj
    }
    
    func getTimeStampStr() -> String {
        guard let date = lastMessageTimeStamp else {
            return ""
        }
        return date.toString()
    }
}
