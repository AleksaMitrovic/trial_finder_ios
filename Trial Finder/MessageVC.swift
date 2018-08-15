//
//  MessageVC.swift
//  Trial Finder
//
//  Created by Kunal Kumar on 12/8/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit
import Firebase
class MessageVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTxtField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var siteListRef: FIRDatabaseReference?

    
    let reuseIdentifier = "messageCell"
    let reuseIdentifier1 = "sentMessageCell"
    var messages = [Message]()
    
    private lazy var messageRef: FIRDatabaseReference = self.siteListRef!.child("messages")
    private var newMessageRefHandle: FIRDatabaseHandle?
    
    var siteList: SiteList? {
        didSet {
            title = siteList?.siteName
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Hello Site"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.messageTableView.estimatedRowHeight = 60.0
        self.messageTableView.rowHeight = UITableViewAutomaticDimension
        
        /** Hiding the extra cell from tableview **/
        self.messageTableView.tableFooterView = UIView()
        self.messageTableView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        self.sendButton.layer.cornerRadius = self.sendButton.layer.frame.width / 2
        
        self.sendButton.layer.borderWidth = 1.0
        self.sendButton.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //            // messages from someone else
        //            addMessage(withId: "foo", name: "Mr.Bolt", text: "I am so fast!")
        //            // messages sent from local sender
        //            addMessage(withId: senderId, name: "Me", text: "I bet I can run faster than you!")
        //            addMessage(withId: senderId, name: "Me", text: "I like to run!")
        //            // animates the receiving of a new message on the view
        //            finishReceivingMessage()
        
        self.observeMessages()
        
    }
    
    @IBAction func send(_ sender: Any) {
    }
    
    // MARK: UITextViewDelegate methods
    
//    private func addMessage(withId id: String, name: String, text: String) {
//        
//         //let message = Message(senderId: id, displayName: name, message: text)
//        
//          //  messages.append(message)
//
//    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
        let messageCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessageCell

        
        return messageCell
        }
        else{
            let sentMessageCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier1, for: indexPath) as! SentMessageCell
            return sentMessageCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef =  messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        
        itemRef.setValue(messageItem) // 3
    }
    
    private func observeMessages() {
        messageRef = siteListRef!.child("messages")
        // 1.
        let messageQuery = messageRef.queryLimited(toLast:50)
        
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
               // self.addMessage(withId: id, name: name, text: text)
                
                // 5
               // self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
    }

}
