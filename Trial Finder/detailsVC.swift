//
//  TrialDetailsVC.swift
//  Trial Finder
//
//  Created by Huynh Danh on 10/18/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation
import MessageUI
import SwiftKeychainWrapper
import Localize_Swift

class detailsVC: UIViewController {
    
    var trial: Trial!
    var siteLists: [SiteList] = []
   // var siteList: SiteList!

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {didSet {nameLabel.text = ""}}
    @IBOutlet weak var detaisLabel: UILabel! {didSet {detaisLabel.text = ""}}
    @IBOutlet weak var phoneLabel: UILabel! {didSet {phoneLabel.text = ""}}
    @IBOutlet weak var emailLabel: UILabel! {didSet {emailLabel.text = ""}}
    @IBOutlet weak var addressLabel: UILabel! {didSet {addressLabel.text = ""}}
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var directionButton: RoundedButton!


    
    
    @IBAction func qw(_ sender: Any) {
        
        performSegue(withIdentifier: "AMCIKVC", sender: self)

    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
    }
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    @IBAction func back(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func call(_ sender: AnyObject) {
        if let phoneNumber = trial.site.phoneNumber, let url = URL(string: "tel://\(phoneNumber)") {
            
            let alertController = UIAlertController(title: phoneNumber, message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(url, options: [:]) { success in
                    print("success: \(success)")
                }
            }))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func email(_ sender: AnyObject) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        if let email = trial.site.email {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([email])
            
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func chat(_ sender: AnyObject)
    {
        
        if(KeychainWrapper.standard.string(forKey: KEY_UID) == nil){
            self.tabBarController?.selectedIndex = 1
            
        } else {
            let siteName = siteLists[0]
            performSegue(withIdentifier: "Chat", sender: siteName)
        }
        
    }
    @IBAction func showDirection(_ sender: AnyObject) {
        if let latitude = trial.site.latitude, let longitude = trial.site.longitude {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            performSegue(withIdentifier: "ShowMaps", sender: location)
        }
        
    }
    
    func setText() {
        self.title = "Trial Details".localized()
        contactLabel.text = "Contact Information:".localized()
        callButton.setTitle("Call".localized(), for: .normal)
        emailButton.setTitle("Email".localized(), for: .normal)
        locationLabel.text = "Location:".localized()
        directionButton.setTitle("Directions to Business".localized(), for: .normal)
    }

    func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        let backBt = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(backClick))
        backBt.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBt
        
        //        self.title = "Trial details"
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setText()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black] //--------V.J--------//
        if let trial = trial {
            nameLabel.text = trial.studyName
            detaisLabel.text = trial.details
            
            if let site = trial.site {
                phoneLabel.text = site.phoneNumber
                emailLabel.text = site.email
                addressLabel.text = site.address
                let id = trial.site.name
                
                if let siteName:String = trial.site.name {
                    
                    //siteList.id = id
                    //siteList.siteName = siteName
                   //siteLists.append(SiteList(id: id, siteName: siteName))
                    
                    self.siteLists.append(SiteList(id: id!, siteName: siteName, subj: trial.studyName))

                    
                }
                
                
                if let url = URL(string: site.logoUrl) {
                    imageView.sd_setImage(with: url)
                }
                
                // call button
                if let phoneNumber = site.phoneNumber, !phoneNumber.isEmpty {
                    callButton.isHidden = false
                } else {
                    callButton.isHidden = true
                }
                // email button
                if let email = site.email, !email.isEmpty {
                    emailButton.isHidden = false
                } else {
                    emailButton.isHidden = true
                }
            
        }
    }
}
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

        if let identifier = segue.identifier {
            if identifier == "ShowMaps" {
                if let location = sender as? CLLocation {
                    let mapsVC = segue.destination as! mapsVC
                    mapsVC.location = location
                }
            }
            else {
                
                if identifier == "Chat"
                {
                   if let siteList = sender as? SiteList {
                    let chatVc = segue.destination as! ChatVC
                    chatVc.senderDisplayName = KeychainWrapper.standard.string(forKey: KEY_EMAIL) /*senderDisplayName*/
                    chatVc.siteName = siteList.siteName
                    chatVc.studynamer = siteList.subj
                    chatVc.siteListRef = DataService.ds.REF_MESSAGES.child(siteLists[0].siteName)
                    chatVc.email = emailLabel.text //------------V.J--------------//
                }
                }
                
            }
        }
    }
    
//    // MARK: Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        
//        /* if let channel = sender as? Channel {
//         */
//        if let siteList = sender as? SiteList {
//            let chatVc = segue.destination as! ChatVC
//            
//            chatVc.senderDisplayName = KeychainWrapper.standard.string(forKey: KEY_UID) /*senderDisplayName*/
//            chatVc.siteList = siteList
//            chatVc.siteListRef = DataService.ds.REF_SITES.child(siteList.id)
//        }
//    }
//}
}

extension detailsVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
