//
//  AppDelegate.swift
//  Trial Finder
//
//  Created by Iran Mateu on 10/9/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import SwiftKeychainWrapper
import UserNotifications
import Messages

let kUserDefault = UserDefaults.standard
let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
let NEW_MESSAGE_NOTIFY_KEY = "NEW_MESSAGE_NOTIFY_KEY"
let notificationNameSignedIn = Notification.Name("SIGNED_IN_SUCCESS")
typealias UserNotificationsExtended = AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var globalFCMToken = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {

        FirebaseApp.configure()

        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        //application.statusBarStyle = .lightContent
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.white
        }
       

        // Requests the notification settings for this app.
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in

            switch settings.authorizationStatus {
            case .authorized:
                print(settings.notificationCenterSetting)
                break
            case .denied:
                print(settings.authorizationStatus)
                // alert user, it's required for this application.
                break
            case .notDetermined:
                print(settings.authorizationStatus)
                // alert user to authorize
                break
            }
        }

        // set user notifications.
        setUserNotifications()


        if UserDefaults.standard.value(forKey: KEY_FIRST_TIME) as? Bool ?? true {
            let _ = KeychainWrapper.standard.removeAllKeys()
            UserDefaults.standard.set(false, forKey: KEY_FIRST_TIME)
            let maxFilterDistance = TFConstants.Distances.count - 1
            UserDefaults.standard.set(maxFilterDistance, forKey: TFUserDefaultsKeys.Distance)
        }

        observeSiteName()

        NotificationCenter.default.addObserver(self, selector: #selector(observeSiteName), name: notificationNameSignedIn, object: nil)

        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                                                                    options: authOptions,
                                                                    completionHandler: { _, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        registerRemoteNotificationIfNeeded()

        // [END register_for_notifications]

        if let token = Messaging.messaging().fcmToken {
            globalFCMToken = token
            print("FCM token: \(token)")
            if let user = Auth.auth().currentUser {
                DataService.ds.REF_FCM_TOKEN.updateChildValues([user.uid: globalFCMToken])
            }
        }

        clearBadge()

        return true
    }

    func registerRemoteNotificationIfNeeded() {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            unregisterRemoteNotification()
        }
    }

    func unregisterRemoteNotification() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        clearBadge()
    }

    func clearBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }


    private func setAction(id: String, title: String, options: UNNotificationActionOptions = []) -> UNNotificationAction {

        let action = UNNotificationAction(identifier: id, title: title, options: options)

        return action
    }


    var countNew = 0
    private var messageRefHandle: DatabaseHandle?
    private var messageRefHandleParent: DatabaseHandle?
    var siteLists: [SiteList] = []
    var readyForSendNotification = false

    func observeSiteName() {

        guard let currentUid = KeychainWrapper.standard.string(forKey: KEY_UID) else {
            return
        }

        messageRefHandleParent = DataService.ds.REF_MESSAGES.observe(.childAdded, with: { (snapshot) -> Void in
            let siteName = snapshot.key

            if snapshot.hasChild(currentUid) {
                let childSnapshot = snapshot.childSnapshot(forPath: currentUid)
                let enumerator = childSnapshot.children
                self.countNew = 0
                self.readyForSendNotification = true
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    let siteList = SiteList(id: "", siteName: siteName, storeName: rest.key, subj: "")
                    self.siteLists.append(siteList)

                    self.messageRefHandle = DataService.ds.REF_MESSAGES.child(siteList.siteName).child(currentUid).child(siteList.storeName)
                        .queryLimited(toLast: 1)
                        .observe(.childAdded, with: { (snapshot) -> Void in

                            if let snapDict = snapshot.value as? [String: AnyObject] {
                                let dater = snapDict["text"]
                                print(dater ?? "jh")

                                if let senderId = snapDict["senderId"] as? String, senderId == currentUid {

                                } else {
                                    let lastStoredMessObject = AppDelegate.getLastMessage(siteList: siteList)

                                    if let timeStamp = (snapDict["timeStamp"] as? String)?.toDate(), let lastMessage = dater as? String, let lastStoredMess = lastStoredMessObject, let storeTimestamp = lastStoredMess.timeStamp.toDate() {
                                        if (lastStoredMess.text == lastMessage && timeStamp.compare(storeTimestamp) == .orderedSame) {
                                        } else {
                                            self.countNew += 1
                                        }
                                    } else {
                                        self.countNew += 1
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
        if countNew > 0 && readyForSendNotification {
            readyForSendNotification = false
        }
    }

    func sendNewMessageNotification () {
        let content = UNContent(title: "New Message",
                                subTitle: "",
                                body: "You got new messages!")

        let request = UNNotificationRequest(identifier: UNIdentifiers.request, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            UNUserNotificationCenter.current().delegate = self
            if (error != nil) {
                //handle here
            }
        }

    }

    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs token retrieved: \(token)")

        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
    }

    func scheduleLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        let snoozeAction = UNNotificationAction (identifier: "Snooze", title: "Snooze", options: .foreground)
        let deleteAction = UNNotificationAction (identifier: "Delete", title: "Delete", options: .destructive)
        let category = UNNotificationCategory(identifier: "UYLReminderCategory", actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: .customDismissAction)
        let categories = NSSet(object: category)
        center.setNotificationCategories(categories as! Set<UNNotificationCategory>)
        let content = UNMutableNotificationContent.init()
        content.title = "Trial Finder"
        content.body = "You got new messages!"
        content.categoryIdentifier = "UYLReminderCategory"
        content.sound = UNNotificationSound.default()

        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            if let _ = error {
                print("Something went wrong: \(String(describing: error))")
            }
        }
    }


    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    static func getLastMessage(siteList: SiteList) -> StoreDataObject? {
        let key = siteList.siteName
        if let data = kUserDefault.data(forKey: key), let object = NSKeyedUnarchiver.unarchiveObject(with: data) as? StoreDataObject {
            return object
        }
        return nil
    }

    static func setLastMessage(siteList: SiteList, senderId: String, message: String, timeStamp: String) {
        let key = siteList.siteName
        let storeObject = StoreDataObject(siteListKey: siteList.siteName, text: message, timeStamp: timeStamp, senderId: senderId)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: storeObject)
        kUserDefault.set(encodedData, forKey: key)

    }
}

extension UserNotificationsExtended {


    /// Set User Notifications
    ///
    /// to init User Notifications Center and manage actions, categories, requests and others..
    ///
    func setUserNotifications() {

        let center = UNUserNotificationCenter.current()

        // define actions
        let ac1 = setAction(id: UNIdentifiers.reply, title: "Reply")
        let ac2 = setAction(id: UNIdentifiers.share, title: "Share")
        let ac3 = setAction(id: UNIdentifiers.follow, title: "Follow")
        let ac4 = setAction(id: UNIdentifiers.destructive, title: "Cancel", options: .destructive)
        let ac5 = setAction(id: UNIdentifiers.direction, title: "Get Direction")

        // define categories
        let cat1 = setCategory(identifier: UNIdentifiers.category, action: [ac1, ac2, ac3, ac4], intentIdentifiers: [])
        let cat2 = setCategory(identifier: UNIdentifiers.customContent, action: [ac5, ac4], intentIdentifiers: [])
        let cat3 = setCategory(identifier: UNIdentifiers.image, action: [ac2], intentIdentifiers: [], options: .allowInCarPlay)

        // Registers your app’s notification types and the custom actions that they support.
        center.setNotificationCategories([cat1, cat2, cat3])

        // Requests authorization to interact with the user when local and remote notifications arrive.
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (success, error) in
            print(error?.localizedDescription ?? "")
        }

    }

    private func setAction(id: String, title: String, options: UNNotificationActionOptions! = []) -> UNNotificationAction {

        let action = UNNotificationAction(identifier: id, title: title, options: options)

        return action
    }

    private func setCategory(identifier: String, action: [UNNotificationAction], intentIdentifiers: [String], options: UNNotificationCategoryOptions = []) -> UNNotificationCategory {

        let category = UNNotificationCategory(identifier: identifier, actions: action, intentIdentifiers: intentIdentifiers, options: options)

        return category
    }
}

/// UNUserNotificationCenterDelegate Extension.
/// Handles notification-related interactions for your app or app extension.
extension UserNotificationsExtended: UNUserNotificationCenterDelegate {

    /// Called when a notification is delivered to a foreground app
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
//        completionHandler( [.alert, .badge, .sound])
    }

    /// Called to let your app know which action was selected by the user for a given notification.
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        let userInfo = response.notification.request.content.userInfo
        handleSelectMessageNotification(userInfo: userInfo)
        print("action selected for notification : \(userInfo)")
    }

    private func handleSelectMessageNotification(userInfo: [AnyHashable: Any]) {
        guard let _ = userInfo["gcm.notification.user_id"] as? String else { return }
        guard let _ = userInfo["gcm.message_id"] as? String else { return }
        guard let siteName = userInfo["gcm.notification.web_site"] as? String else { return }
        guard let storeName = userInfo["gcm.notification.web_store"] as? String else { return }
        let siteList = SiteList(id: "", siteName: siteName, storeName: storeName, subj: storeName)
        guard let chatVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as? ChatVC else { return }
        guard let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? SWRevealViewController else { return }
        let navigationVC = UINavigationController()
        navigationVC.navigationBar.barStyle = .black
        navigationVC.navigationBar.barTintColor = UIColor.white
        navigationVC.navigationBar.isTranslucent = false
        chatVc.senderDisplayName = KeychainWrapper.standard.string(forKey: KEY_EMAIL) /*senderDisplayName*/

        chatVc.siteList = siteList
        chatVc.siteName = siteList.siteName
        chatVc.studynamer = siteList.storeName
        chatVc.isRemote = true
        chatVc.siteListRef = DataService.ds.REF_MESSAGES.child(siteList.siteName)
        let full_sitename = siteList.siteName
        let siteId = full_sitename.replacingOccurrences(of: " ", with: "")
        DataService.ds.REF_SITES.child(siteId).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.value as? [String: AnyObject]{
                chatVc.email = snapshot["email"] as? String
            }
        })
        rootVC.setFront(chatVc, animated: false)
        window?.rootViewController = navigationVC
        navigationVC.pushViewController(chatVc, animated: false)
    }
}

extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        globalFCMToken = fcmToken
        if let user = Auth.auth().currentUser {
            DataService.ds.REF_FCM_TOKEN.updateChildValues([user.uid: globalFCMToken])
//        DataService.ds.REF_USERS.child(user.uid).updateChildValues(["fcmToken": globalFCMToken])
        }

    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}


