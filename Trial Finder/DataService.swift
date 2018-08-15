//
//  DataService.swift
//  Trial Finder
//
//  Created by Iran Mateu on 10/12/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    //Reference to DB
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_SITES = DB_BASE.child("sites")
    private var _REF_TRIALS = DB_BASE.child("trials")
    var _REF_MESSAGES = DB_BASE.child("messages")
    private var _REF_FCM_TOKEN = DB_BASE.child("fcmToken")
    private var _REF_MESSAGES_HANDLE: DatabaseHandle?

    
    
    //Reference to Storage
    private var _REF_TRIAL_IMAGES = STORAGE_BASE.child("condition-icons")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_SITES: DatabaseReference {
        return _REF_SITES
    }
    
    var REF_MESSAGES : DatabaseReference {
        return _REF_MESSAGES
    }
    
    var REF_TRIALS: DatabaseReference
    {
        return _REF_TRIALS
    }
    
    var REF_TRIAL_IMAGES: StorageReference {
        return _REF_TRIAL_IMAGES
    }
    
    var REF_FCM_TOKEN : DatabaseReference {
        return _REF_FCM_TOKEN
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    
}
