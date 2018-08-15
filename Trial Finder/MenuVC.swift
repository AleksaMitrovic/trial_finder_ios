//
//  MenuVC.swift
//  Trial Finder
//
//  Created by Huynh Danh on 10/16/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import Localize_Swift

class MenuVC: UIViewController {
    
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var newMessageImage: UIImageView!
    
    
    @IBOutlet weak var signedInAsLabel: UILabel!
    @IBOutlet weak var mainFeedButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

    
    @IBAction func showMainFeed(_ sender: AnyObject) {
        self.revealViewController().revealToggle(sender)
    }
    
    private var messageRefHandle: DatabaseHandle?
    var siteLists: [SiteList] = []
    
    @IBAction func logout(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        let keychainEmail = KeychainWrapper.standard.removeObject(forKey: KEY_EMAIL)
        print("ID Removed from keychain\(keychainResult)")
        print("Email Removed from keychain\(keychainEmail)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        kAppDelegate.unregisterRemoteNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        setText()
        
        if let user = Auth.auth().currentUser, let _ = KeychainWrapper.standard.string(forKey: KEY_UID)  {
            accountLabel.text = user.email
        } else {
            logoutButton.setTitle("LogIn".localized(), for: .normal)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(observeSiteName), name: notificationNameSignedIn, object: nil)
    }
    
    func setText() {
        signedInAsLabel.text = "You are signed in as".localized().uppercased()
        mainFeedButton.setTitle("Trials".localized(), for: .normal)
        settingsButton.setTitle("Settings".localized(), for: .normal)
        logoutButton.setTitle("Logout".localized(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeSiteName()
    }

    
    var countNew = 0
    func observeSiteName() {
        
        guard let currentUid = KeychainWrapper.standard.string(forKey: KEY_UID) else {
            return
        }
//        let currentUid = (FIRAuth.auth()?.currentUser?.uid)!
        
        messageRefHandle = DataService.ds.REF_MESSAGES.observe(.childAdded, with: { (snapshot) -> Void in
            let siteName = snapshot.key
            if snapshot.hasChild(currentUid) {
                let childSnapshot = snapshot.childSnapshot(forPath: currentUid)
                let enumerator = childSnapshot.children
                self.countNew = 0
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    let siteList = SiteList(id: "", siteName: siteName, storeName: rest.key, subj: "")
                    self.siteLists.append(siteList)
                    
                    self.messageRefHandle = DataService.ds.REF_MESSAGES.child(siteList.siteName).child(currentUid).child(siteList.storeName)
                        .queryLimited(toLast: 1)
                        .observe(.childAdded, with: { (snapshot) -> Void in
                            
                            print(snapshot.value)
//                            siteListCell.lastmessage?.text = snapshot.key
                            
                            if let snapDict = snapshot.value as? [String: AnyObject] {
                                let dater = snapDict["text"]
                                if let text = dater as? String, text.characters.count > 0  {
                                    
                                    
                                    print(dater ?? "jh")
                                    //                                siteListCell.lastmessage?.text = dater as! String?
                                    
                                    if let senderId = snapDict["senderId"] as? String, senderId == currentUid {
                                        //                                    siteListCell.newMessageView.isHidden = true
                                    } else {
                                        let lastStoredMessObject = AppDelegate.getLastMessage(siteList: siteList)
                                        
                                        if let timeStamp = (snapDict["timeStamp"] as? String)?.toDate(), let lastMessage = dater as? String, let lastStoredMess = lastStoredMessObject, let storeTimestamp = lastStoredMess.timeStamp.toDate() {
                                            if (lastStoredMess.text == lastMessage && timeStamp.compare(storeTimestamp) == .orderedSame) {
                                                //                                            siteListCell.newMessageView.isHidden = true
                                            } else {
                                                //                                            siteListCell.newMessageView.isHidden = false
                                                self.countNew += 1
                                            }
                                        } else {
                                            //                                        siteListCell.newMessageView.isHidden = false
                                            self.countNew += 1
                                        }
                                    }
                                }
                            }
                            self.calculateNewMess()
                        })
                }
                
            }
        })
    }
    
    func calculateNewMess() {
        if countNew > 0 {
            self.newMessageImage.isHidden = false
        } else {
            self.newMessageImage.isHidden = true
        }
    }
    
    
}
