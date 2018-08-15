//
//  SiteListVC.swift
//  Trial Finder
//
//  Created by Milan Garg on 12/5/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SiteListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var messageRefHandle: DatabaseHandle?
    var siteLists: [SiteList] = []
    var senderDisplayName: String?
    var sites = [Site]()
    let reuseIdentifier = "siteList"

    @IBOutlet weak var siteListTableView: UITableView!

    @IBAction func showMenu(_ sender: Any) {
        self.revealViewController().revealToggle(sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.siteListTableView.estimatedRowHeight = 44
        self.siteListTableView.rowHeight = UITableViewAutomaticDimension
        /** setting the seperator inset to zero **/
        self.siteListTableView.separatorInset = .zero

        /** Hiding the extra cell from tableview **/
        self.siteListTableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if (KeychainWrapper.standard.string(forKey: KEY_UID) == nil) {
            performSegue(withIdentifier: "DONUSBIR", sender: nil)
        } else {
            self.observeSiteName()
        }
        super.viewWillAppear(animated)
        kAppDelegate.clearBadge()
        updateNewMessageBadge()
    }

    deinit {
        if let refHandle = messageRefHandle {
            DataService.ds.REF_SITES.removeObserver(withHandle: refHandle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func observeSiteName() {
        // Move to a background thread to do some long running work
        DispatchQueue.global(qos: .userInitiated).async {

            if let currentUid = Auth.auth().currentUser?.uid {
                self.messageRefHandle = DataService.ds.REF_MESSAGES.observe(.value, with: { (snapshot) -> Void in
                    let messageEnumerator = snapshot.children
                    var newList = [SiteList]()
                    while let messChildDataSnapshot = messageEnumerator.nextObject() as? DataSnapshot {
                        let siteName = messChildDataSnapshot.key
                        if messChildDataSnapshot.hasChild(currentUid) {
                            let childSnapshot = messChildDataSnapshot.childSnapshot(forPath: currentUid)
                            let enumerator = childSnapshot.children
                            while let rest = enumerator.nextObject() as? DataSnapshot, !rest.key.contains("number") {

                                let siteListItem = SiteList(id: "", siteName: siteName, storeName: rest.key, subj: "")
                                var listMessage = [(String, String, String, Int)]()
                                let childEnumerator = messChildDataSnapshot.childSnapshot(forPath: currentUid).childSnapshot(forPath: rest.key).children

                                while let restChild = childEnumerator.nextObject() as? DataSnapshot {
                                    if let dataDict = restChild.value as? [String: AnyObject] {
                                        var message = ""
                                        var timeStamp = ""
                                        var senderId = ""
                                        var number = 0
                                        for (key, value) in dataDict {
                                            //                                            print("===== \(key) \(value)")
                                            if key == "text", let v = value as? String {
                                                message = v
                                            }
                                            if key == "timeStamp", let v = value as? String {
                                                timeStamp = v
                                            }
                                            if key == "senderId", let v = value as? String {
                                                senderId = v
                                            }
                                            if key == "number", let v = value as? Int {
                                                number = v
                                            }
                                            if !timeStamp.isEmpty, !message.isEmpty {
                                                listMessage.append((message, timeStamp, senderId, number))
                                            }
                                        }
                                    }
                                }
                                listMessage = listMessage.sorted(by: { (v1, v2) -> Bool in
                                    return v1.3 < v2.3
                                })

                                if let lastItem = listMessage.last {
                                    siteListItem.lastMessage = lastItem.0
                                    siteListItem.lastMessageTimeStamp = lastItem.1.toDate()
                                    siteListItem.lastSenderId = lastItem.2
                                    siteListItem.lastMessageOrderNumber = lastItem.3

                                    if siteListItem.lastSenderId == currentUid {
                                        siteListItem.isNew = false
                                    } else {
                                        let lastStoredMessObject = AppDelegate.getLastMessage(siteList: siteListItem)

                                        if let timeStamp = siteListItem.lastMessageTimeStamp, let lastStoredMess = lastStoredMessObject, let storeTimestamp = lastStoredMess.timeStamp.toDate() {
                                            if (lastStoredMess.text == lastItem.0 && timeStamp.compare(storeTimestamp) == .orderedSame) {
                                                siteListItem.isNew = false
                                            } else {
                                                siteListItem.isNew = true
                                            }
                                        } else {
                                            siteListItem.isNew = true
                                        }
                                    }
                                }
                                var isDeleted = false
                                if rest.key.contains("isDeleted"), let deleted = rest.value as? Bool {
                                    isDeleted = deleted
                                }
                                siteListItem.isDeleted = isDeleted
                                if !isDeleted {
                                    newList.append(siteListItem)
                                } else {
                                    newList = newList.filter({ $0.siteName != siteListItem.siteName })
                                }
                            }
                        }
                    }

                    // Bounce back to the main thread to update the UI
                    DispatchQueue.main.async {
                        if newList.count > 0 {
                            newList = newList.filter({ $0.storeName != "isDeleted" })
                            newList = newList.sorted(by: { (s1, s2) -> Bool in
                                guard let d1 = s1.lastMessageTimeStamp else { return false }
                                guard let d2 = s2.lastMessageTimeStamp else { return false }
                                return d1.compare(d2) == .orderedDescending
                            })
                            self.siteLists.removeAll()
                            self.siteLists.append(contentsOf: newList)
                            self.siteListTableView.reloadData()
                            self.updateNewMessageBadge()
                        }
                    }
                })
            }
        }
    }

    func updateNewMessageBadge() {
        let currentUser = Auth.auth().currentUser
        if let items = self.tabBarController?.tabBar.items {
            let messageTab = items[1]
            let isNewMes = self.siteLists.filter({ $0.isNew }).count
            messageTab.badgeValue = isNewMes == 0 || currentUser == nil ? nil : ""
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.siteLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let siteListCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SiteListCell
        let siteList = siteLists[indexPath.row]

        siteListCell.siteName?.text = siteList.siteName
        siteListCell.lbStoreName?.text = siteList.storeName
        siteListCell.lastmessage.text = siteList.lastMessage
        siteListCell.newMessageView.isHidden = !siteList.isNew

        return siteListCell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let currentUserId = Auth.auth().currentUser?.uid {
                let siteItem = siteLists[indexPath.row]
                DataService.ds.REF_MESSAGES.child(siteItem.siteName).child(currentUserId).updateChildValues(["isDeleted": true])
                siteLists.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    func resortSiteList() {
        if siteLists.count == 0 {
            return
        }
        let sortedList = siteLists.sorted(by: { (s1, s2) -> Bool in
            guard let d1 = s1.lastMessageTimeStamp else { return false }
            guard let d2 = s2.lastMessageTimeStamp else { return false }
            return d1.compare(d2) == .orderedDescending
        })
        if let topSorted = sortedList.first, let topSiteList = siteLists.first {
            if topSorted.lastMessage != topSiteList.lastMessage && topSorted.getTimeStampStr() != topSiteList.getTimeStampStr() {
                siteLists.removeAll()
                siteLists.append(contentsOf: sortedList)
                siteListTableView.reloadData()
            }
        }
    }

    func moveRowToTop(indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        let currentItem = siteLists[indexPath.row]
        siteLists.remove(at: indexPath.row)
        siteLists.insert(currentItem, at: 0)
        siteListTableView.reloadData()
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let siteName = siteLists[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "ShowMessage", sender: siteName)
    }

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        /* if let channel = sender as? Channel {
         */
        if let siteList = sender as? SiteList {
            let chatVc = segue.destination
            as! ChatVC
            chatVc.senderDisplayName = KeychainWrapper.standard.string(forKey: KEY_EMAIL) /*senderDisplayName*/

            chatVc.siteList = siteList

            chatVc.siteName = siteList.siteName
//            chatVc.siteName = "AGA Clinical Trials"
            chatVc.studynamer = siteList.storeName
//            chatVc.siteListRef = DataService.ds.REF_MESSAGES.child("AGA Clinical Trials")
            chatVc.siteListRef = DataService.ds.REF_MESSAGES.child(siteList.siteName)
            
//--------------V.J---------------//
            let full_sitename = siteList.siteName
            let siteId = full_sitename.replacingOccurrences(of: " ", with: "")
            DataService.ds.REF_SITES.child(siteId).observe(.value, with: { (snapshot) in
                if let snapshot = snapshot.value as? [String: AnyObject]{
                    chatVc.email = snapshot["email"] as? String
                }
            })
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let messageDate = dateFormatter.string(from: self)
        return messageDate
    }
}
