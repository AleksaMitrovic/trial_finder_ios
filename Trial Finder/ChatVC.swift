//
//  ChatVC.swift
//  Trial Finder
//
//  Created by Kunal Kumar on 12/18/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import SwiftKeychainWrapper
import MessageUI   //----------V.J-----------//
import MailgunSwift


//final class ChatVC: JSQMessagesViewController, MFMailComposeViewControllerDelegate {
final class ChatVC: JSQMessagesViewController {
    var messages = [JSQMessage]()
    
    var siteListRef: DatabaseReference?

    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var siteName:String?
    var studynamer:String?
    var email:String?//--------------V.J----------------//
    var isShowing = false
    var globalNumber = 0
    var isRemote = false
    var message_content:String?//------------V.J---------------//
    
    private var newMessageRefHandle: DatabaseHandle?

    var siteList: SiteList? {
        didSet {
            title = siteList?.siteName
        }
    }
    private lazy var messageRef: DatabaseReference = self.siteListRef!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // Do any additional setup after loading the view.
        self.senderId = Auth.auth().currentUser?.uid
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.inputToolbar.contentView.leftBarButtonItem = nil;
        self.inputToolbar.contentView.textView.placeHolder = "Type your message..."
        
        self.inputToolbar?.contentView.rightBarButtonItem?.setImage(UIImage(named: "send"), for: .normal)
        self.inputToolbar?.contentView.rightBarButtonItem?.backgroundColor = UIColor.green
        
        self.inputToolbar?.contentView.rightBarButtonItem?.setTitle("", for: .normal)
        
        self.inputToolbar?.contentView.rightBarButtonItem?.layer.cornerRadius = (self.inputToolbar?.contentView.rightBarButtonItem?.layer.frame.height)! / 2
        self.inputToolbar?.contentView.rightBarButtonItem?.layer.borderColor = UIColor.green.cgColor
        self.inputToolbar?.contentView.rightBarButtonItem?.layer.borderWidth = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let backBt = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(backClick))
        backBt.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBt
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as! [String : Any]
        super.viewWillAppear(animated)
        if isRemote {
            
            if let rootVC = UIStoryboard(name: "MainTab", bundle: nil).instantiateInitialViewController() {
                self.navigationController?.viewControllers = [rootVC, self]
            }
        }
        self.navigationItem.title = siteList?.siteName ?? siteName  
    }
    
    func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // animates the receiving of a new message on the view

        self.observeMessages()
        isShowing = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isRemote {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        super.viewWillDisappear(animated)
        isShowing = false
    }
    
    // MARK: Collection view data source (and related) methods
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.white
        }
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
       // if (indexPath.item % 3 == 0) {
            let message = self.messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
       // }
        
       // return nil

    }

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        //if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
       // }
        
       // return 0.0
    }




    
    // MARK: UI and User Interaction
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        
        
         let bubbleImageFactory = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: .zero)
        
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.outgoingMessageBubbleColor())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        
        let bubbleImageFactory = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: .zero)

        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.lightGray)
    }
    
    // MARK: UITextViewDelegate methods
    
    private func addMessage(withId id: String, name: String, timeStamp: Date, text: String) {
        if let message = JSQMessage(senderId: id, senderDisplayName: name, date:timeStamp, text: text) {
            messages.append(message)
            
            if let siteList = self.siteList, message.senderId != senderId && isShowing {
                AppDelegate.setLastMessage(siteList: siteList, senderId: self.senderId, message: text, timeStamp: dateToString(date: timeStamp))
            }
        }

    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sss.SSS'Z'"
//        let messageDate = dateFormatter.string(from: date)
        let messageDate = dateToString(date: date)
        //let subj = subj
        let itemRef =  messageRef.child(studynamer!).childByAutoId() // 1
        globalNumber += 1
        
        let messageItem = [ // 2
            "fcmToken": kAppDelegate.globalFCMToken,
            "number": globalNumber,
            "senderId": senderId!,
            "senderName": senderDisplayName,
            "text": text!,
            "timeStamp": messageDate,
            "subj": studynamer ?? ""
            ] as [String : Any]
        
        messageRef.updateChildValues(["number": globalNumber])
        itemRef.setValue(messageItem) // 3
        
        //----------V.J-----------//
        message_content = text

        let user_email = KeychainWrapper.standard.string(forKey: KEY_EMAIL)
        let admin_email = email
        let message = MailgunMessage(from:user_email!,
                                     to:admin_email!,
                                     message:"Mailgun is awesome!",
                                     body:message_content!)

        let mailgun = Mailgun(apiKey: "1de97f7b21ffa395bb2024f8d3f15a4d-7efe8d73-f2d9ebe6", domain: "sandbox786cb6fc76bc49a2b1bc13dd09d0f5d0.mailgun.org")
        mailgun.send(message: message) { result in
            switch result {
            case .success(let messageId):
                print(messageId)
            case .failure(let error):
                print(error)
            }
        }
 
        finishSendingMessage() // 5
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let messageDate = dateFormatter.string(from: date)
        return messageDate
    }

    private func observeMessages() {
        messageRef = siteListRef!.child((Auth.auth().currentUser?.uid)!)
        // 1.
        let messageQuery = messageRef.child(studynamer!).queryLimited(toLast:100)
        
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            
            // 3
            let messageData = snapshot.value as? Dictionary<String, Any>

            if let id = messageData?["senderId"] as? String, let name = messageData?["senderName"] as? String, let timeStamp:String = messageData?["timeStamp"] as? String, let text = messageData?["text"] as? String, text.characters.count > 0, let dateTimeStamp = timeStamp.toDate() {
                self.addMessage(withId: id, name: name, timeStamp: dateTimeStamp, text: text)
                
                // 5
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
        
        messageRef.observe(.value, with: { [weak self](snapshot) in
            if let messageData = snapshot.value as? Dictionary<String, Any> {
                
                if let number = messageData["number"] as? Int {
                    print("------number change \(number)")
                    self?.globalNumber = number
                }
                
            } else {
                print("Error! Could not decode number data")
            }
        })
        
    }

}
