//
//  ViewController.swift
//  Trial Finder
//
//  Created by Iran Mateu on 10/9/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper
import Localize_Swift

let kOtherLoginNotification = "kOtherLoginNotification"

class SignInVC: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var loginEmailField: BottomLineTextField!
    @IBOutlet weak var loginPasswordField: BottomLineTextField!
    
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            errorLabel.text = ""
        }
    }
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signinButton: RoundedButton!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var userEmail:String?
    var firstLogin:Bool?
    var referrer:String?

    @IBAction func klose(_ sender: Any) {
//        performSegue(withIdentifier: "goToFeed", sender: nil)

    }
      // @IBOutlet weak var first: UITextField!
//    func getData() -> [String: Any] {
//        var data: [String: Any] = [:]
//        
//    
//            data["firstName"] = supfull.text!
//            data["lastName"] = last.text!
//
// 
//        data["firstLogin"] = "yes"
//        
//        return data
//    }
    
//    func updateInfo() {
//        errorLabel.text = ""
//        
//        if (!self.supfull.hasText || !self.supemail.hasText || (self.suppass.text! != self.prepeat.text!))
//        {
//            errorLabel.text = "Please check your details".uppercased()
//            self.showActivityIndicator(isShow: false, activityIndicatorView: activityIndicator)
//        }
//        else
//        {
//            
//            let data = getData()
//            
//            
//            signin(email: self.supemail.text!, password: self.suppass.text!) { error in
//                if let _ = error {
//                    
//                    /** stop activity indicator **/
//                    self.showActivityIndicator(isShow: false, activityIndicatorView: self.activityIndicator)
//                    
//                    self.errorLabel.text = "Wrong password".uppercased()
//                }
//            }
//            
//                            FIRAuth.auth()?.createUser(withEmail: self.supemail.text!, password: self.suppass.text!, completion: { (user, error) in
//            
//                                if error != nil {
//                                    print("unable to authenticate with firebase using email")
//                                    //completion(error)
//                                } else {
//                                    print("Succesfully authenticated with firebase")
//                                    if let user = user {
//                                      // let userData = ["provider": user.providerID]
//                                        self.userEmail = user.email
//                                 
//                                        self.completeSignIn(id: user.uid, userData: data as! Dictionary<String, String>)
//                                    }
//                                }
//                            })
//        }
//    }
    
//    @IBAction func sw(_ sender: UISegmentedControl) {
//        switch sw.selectedSegmentIndex
//        {
//        case 0:
//            vloginpanel.isHidden = false
//           vregpanel.isHidden = true
//
//
//        case 1:
//            vloginpanel.isHidden = true
//            vregpanel.isHidden = false
//
//        default:
//            break;
//        }
//        
//    }
    @IBAction func facebookSignInButton(_ sender: AnyObject) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("User cancelled Facebook authentication")
            } else {
                print ("User succesdfullly authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(otherLogin), name: notificationNameSignedIn, object: nil)
        setText()
        //      navbar.topItem?.title = "Welcome!"
        //       // vlogin.layer.cornerRadius = 15
        //        vlogin.layer.cornerRadius = 15
        //        vreg.layer.cornerRadius = 15
        ////vreg.isHidden = true
        //        vregpanel.isHidden = true
    }
    func otherLogin() {
        self.navigationController?.popViewController(animated: true)
    }
    

    func setText() {
        titleLabel.text = "Login".localized()
        loginEmailField.placeholder = "Email address".localized()
        loginPasswordField.placeholder = "Password".localized()
        noteLabel.text = "If an account doesn't exist, one will be created for you".localized()
        forgotPasswordButton.setTitle("Forgot Password?".localized(), for: .normal)
        signinButton.setTitle("Sign in".localized(), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
//            performSegue(withIdentifier: "goToFeed", sender: nil)
//            
//        }
    }

    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to authenticate user with Firebase - \(error)")
            } else {
                print("User succesfully authenticated")
                
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.userEmail = user.email
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
            
    }
    
    @IBAction func signInButton(_ sender: AnyObject) {
        signin()
    }
    
    func changeColor(for textField: BottomLineTextField, withColor color: UIColor = UIColor.black) {
        textField.borderColor = color
        textField.textColor = color
        textField.setNeedsDisplay()
    }
    
    func signin() {
        // reset UI to normal state
        changeColor(for: loginEmailField)
        changeColor(for: loginPasswordField)
        errorLabel.text = ""
        
        guard let email = loginEmailField.text, email.contains("@") else {
            errorLabel.text = "Email is Invalid".localized().uppercased()
            changeColor(for: loginEmailField, withColor: UIColor.red)
            return
        }
        
        guard let password = loginPasswordField.text, password.characters.count >= 6 else {
            errorLabel.text = "Password id Invalid".localized().uppercased()
            changeColor(for: loginPasswordField, withColor: UIColor.red)
            return
        }
        
        signin(email: email, password: password) { error in
            if let _ = error {
                
                /** stop activity indicator **/
                self.showActivityIndicator(isShow: false, activityIndicatorView: self.activityIndicator)
                
                self.errorLabel.text = "Wrong password".uppercased()
            }
        }
    }
    
    func signin(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        /** show activity indicator **/
        self.showActivityIndicator(isShow: true, activityIndicatorView: activityIndicator)

        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            /** stop activity indicator **/
            self.showActivityIndicator(isShow: false, activityIndicatorView: self.activityIndicator)
            
            if error == nil {
                print("user authenticated succesfully")
                if let user = user {
                    let userData = ["provider": user.providerID]
                    self.setLanguage(user: user)
                    self.userEmail = user.email
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            } else {
//                self.vloginpanel.isHidden = true
//                self.vregpanel.isHidden = false
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    
                    if error != nil {
                        print("unable to authenticate with firebase using email")
                        completion(error)
                    } else {
                        print("Succesfully authenticated with firebase")
                        if let user = user {
                            let userData = ["provider": user.providerID]
                            self.userEmail = user.email
                            self.completeSignIn(id: user.uid, userData: userData)
                        }
                    }
                })
            }
        })
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        if let email = userEmail {
            let keychainEmail = KeychainWrapper.standard.set(email, forKey: KEY_EMAIL)
            print("Data saved to keychain \(keychainResult), \(keychainEmail)")
        }
        
        self.afterSignInSuccess()
        
//        if firstLogin!
//        {
//            performSegue(withIdentifier: "goToFeed", sender: nil)
//        }
//        else{
//            performSegue(withIdentifier: "firsLogin", sender: nil)
//
//        
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    func setLanguage(user: User) {
        
        DataService.ds.REF_USERS.child(user.uid).observe(.value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                
                if let language = dict["language"] as? String,
                    Localize.availableLanguages().contains(language) {
                    
                    Localize.setCurrentLanguage(language)
                }
            }
        })
    }
    
    func afterSignInSuccess() {
        
        if let user = Auth.auth().currentUser {
            DataService.ds.REF_USERS.child(user.uid).observe(.value, with: { (snapshot) in
                
                print ("snapshot---\(snapshot)")
            
                if snapshot.hasChild("firstLogin")
                {
                    print("in if")
                   // self.firstLogin = true
//                    self.performSegue(withIdentifier: "goToFeed", sender: nil)
                    if self.isBeingPresented {
                        self.dismiss(animated: true, completion: nil)
                    }else {
                     self.navigationController?.popViewController(animated: true)
                    }
                }
                else
                {
                    print("in else")
                    if self.isBeingPresented {
                        self.dismiss(animated: true, completion: nil)
                    }else {
                        self.navigationController?.popViewController(animated: true)
                    }
                  //  self.firstLogin = false
//                    self.performSegue(withIdentifier: "goToFeed", sender: nil)
                }
                
                NotificationCenter.default.removeObserver(self)
                NotificationCenter.default.post(name: notificationNameSignedIn, object: nil)
            })
            DataService.ds.REF_FCM_TOKEN.updateChildValues([user.uid: kAppDelegate.globalFCMToken])
//            DataService.ds.REF_USERS.child(user.uid).updateChildValues(["fcmToken": kAppDelegate.globalFCMToken])
        }
        kAppDelegate.registerRemoteNotificationIfNeeded()
    }
    
}

extension SignInVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let textField = textField as? BottomLineTextField {
            changeColor(for: textField)
            errorLabel.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
