//
//  SettingsVC.swift
//  Trial Finder
//
//  Created by Huynh Danh on 10/16/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit
import Firebase
import ActionSheetPicker_3_0
import Localize_Swift
import SwiftKeychainWrapper

class SettingsVC: UIViewController {
    
    // MARK: Properties
    
    var user: UserModel!
    
    let languages = [ "en": "English", "es": "Español" ]
    
    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // information
    
    @IBOutlet weak var informationLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var sexTextField: UITextField!
    
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightFeetTextField: UITextField!
    @IBOutlet weak var heightInchesTextField: UITextField!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var updateInfoButton: UIButton!
    
    // password
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var currentPasswordLabel: UILabel!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var changePasswordButton: UIButton!
    
    // language
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var currentLanguageLabel: UILabel!
    @IBOutlet weak var currentLanguageTextField: UITextField!
    
    @IBOutlet weak var setLanguageButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    //login
    @IBOutlet weak var loginLabel: UILabel!
    
    
    @IBOutlet weak var informationView: UIView! {
        didSet {
            informationView.layer.cornerRadius = 5.0
            informationView.layer.borderWidth = 0.5
            informationView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.25).cgColor
        }
    }
    @IBOutlet weak var securityView: UIView! {
        didSet {
            securityView.layer.cornerRadius = 5.0
            securityView.layer.borderWidth = 0.5
            securityView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.25).cgColor
        }
    }
    @IBOutlet weak var languageView: UIView! {
        didSet {
            languageView.layer.cornerRadius = 5.0
            languageView.layer.borderWidth = 0.5
            languageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.25).cgColor
        }
    }
    
    // MARK: Actions
    
    @IBAction func showMenu(_ sender: AnyObject) {
//        self.revealViewController().revealToggle(sender)
    }
    
    @IBAction func updateInfo(_ sender: AnyObject) {
        updateInfo()
    }
    
    @IBAction func changePassword(_ sender: AnyObject) {
        changePassword()
    }
    
    @IBAction func setLanguage(_ sender: AnyObject) {
        updateLanguage()
    }
    
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { [weak self] action in
            let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
            let keychainEmail = KeychainWrapper.standard.removeObject(forKey: KEY_EMAIL)
            print("ID Removed from keychain\(keychainResult)")
            print("Email Removed from keychain\(keychainEmail)")
            try! Auth.auth().signOut()
            self?.performSegue(withIdentifier: "goToSignInF", sender: nil)
            kAppDelegate.unregisterRemoteNotification()
            if let items = self?.tabBarController?.tabBar.items {
                let messageTab = items[1]
                messageTab.badgeValue = nil
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // done
        let toolbarDone = UIToolbar()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem(title: "Done".localized(), style: .done, target: self, action: #selector(doneClick))
        
        toolbarDone.items = [barBtnDone]
        heightFeetTextField.inputAccessoryView = toolbarDone
        heightInchesTextField.inputAccessoryView = toolbarDone
        weightTextField.inputAccessoryView = toolbarDone
        
        // localize
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setText()
        
        loginLabel.text = "Logout".localized()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let currentUser = Auth.auth().currentUser, let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            getUserInfo(currentUser: currentUser) { (user) in
                if let user = user {
                    self.user = user
                    self.reloadData(user: user)
                }
            }
        } else {
            performSegue(withIdentifier: "goToSignInF", sender: nil)
            return
        }
        super.viewWillAppear(animated)
        // keyboard
        subscribeToNotification(notification: .UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(notification: .UIKeyboardWillChangeFrame, selector: #selector(keyboardWillChangeFrame))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromAllNotifications()
    }
    
    func getUserInfo(currentUser: User, completion: @escaping (_ user: UserModel?) -> Void) {
        DataService.ds.REF_USERS.child(currentUser.uid).observe(.value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let currentUser = UserModel(dict: dict)
                completion(currentUser)
            }
        })
    }
    
    func reloadData(user: UserModel) {
        firstNameTextField.text = user.firstName ?? ""
        lastNameTextField.text = user.lastName ?? ""
        
        if let isMale = user.isMale {
            sexTextField.text = isMale ? "Male".localized() : "Female".localized()
        }
        
        if let birthdate = user.birthdate {
            birthdateTextField.text = getDateString(date: birthdate)
            
            if let age = getAge(birthdate: birthdate) {
                ageTextField.text = "\(age)"
            }
        } else {
            birthdateTextField.text = ""
            ageTextField.text = ""
        }
        
        if let weight = user.weight {
            weightTextField.text = "\(weight)"
        } else {
            weightTextField.text = ""
        }
        
        if let height = user.height {
            let values = getHeight(height: height)
            heightFeetTextField.text = "\(values.feet)"
            heightInchesTextField.text = "\(values.inches)"
        } else {
            heightFeetTextField.text = ""
            heightInchesTextField.text = ""
        }
        
        if let lang = user.language { currentLanguageTextField.text = languages[lang] }
    }
    
    func getData() -> [String: Any] {
        var data: [String: Any] = [:]
        
        if let firstName = firstNameTextField.text {
            data["firstName"] = firstName
        }
        
        if let lastName = lastNameTextField.text {
            data["lastName"] = lastName
        }
        
        if let sex = sexTextField.text {
            data["isMale"] = sex == "Male".localized()
        }
        
        if let birthdateText = birthdateTextField.text, let birthdate = getDateFrom(string: birthdateText) {
            data["birthdate"] = birthdate.timeIntervalSince1970
        }
        
        if let weightText = weightTextField.text {
            data["weight"] = Double(weightText) ?? 0.0
        }
        
        if let height = getHeightFromTextFields() {
            data["height"] = height
        }
        
        return data
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Settings".localized(), message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor(red: 255.0 / 255.0, green: 49.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setText() {
        
        titleLabel.text = "Settings".localized()
        
        // information
        
        informationLabel.text = "Information".localized().uppercased()
        
        nameLabel.text = "Name".localized()
        firstNameTextField.placeholder = "First Name".localized()
        lastNameTextField.placeholder = "Last Name".localized()
        
        sexLabel.text = "Sex".localized()
        if let user = self.user, let isMale = user.isMale {
            sexTextField.text = isMale ? "Male".localized() : "Female".localized()
        }
        
        birthdateLabel.text = "Birth date".localized()
        ageTextField.placeholder = "Age".localized()
        
        heightLabel.text = "Height".localized()
        heightFeetTextField.placeholder = "Feet".localized()
        heightInchesTextField.placeholder = "Inches".localized()
        
        weightLabel.text = "Weight".localized()
        weightTextField.placeholder = "Pounds".localized()
        
        updateInfoButton.setTitle("Update".localized(), for: .normal)
        
        // password
        
        passwordLabel.text = "Password".localized().uppercased()
        
        currentPasswordLabel.text = "Current Password".localized()
        
        newPasswordLabel.text = "New Password".localized()
        newPasswordTextField.placeholder = "at least 6 characters".localized()
        
        changePasswordButton.setTitle("Change".localized(), for: .normal)
        
        // language
        
        languageLabel.text = "Language".localized().uppercased()
        
        currentLanguageLabel.text = "Current Language".localized()
        
        setLanguageButton.setTitle("Set".localized(), for: .normal)
    }
    
    func updateInfo() {
        let data = getData()
        
        if let user = Auth.auth().currentUser {
            
            DataService.ds.REF_USERS.child(user.uid).updateChildValues(data, withCompletionBlock: { (error, ref) in
                
                if let error = error {
                    print(error.localizedDescription)
                    self.showAlert(message: "Could not update information".localized())
                    return
                }
                
                self.showAlert(message: "Information is changed".localized())
            })
        }
    }
    
    // For example: "English" -> "en"
    private func languageCode(from language: String) -> String? {
        for (key, value) in languages {
            if value == language { return key }
        }
        return nil
    }
    
    func updateLanguage() {
        
        if let language = currentLanguageTextField.text, let lang = languageCode(from: language) {
            
            // set language
            Localize.setCurrentLanguage(lang)
            
            // update Firebase
            if let user = Auth.auth().currentUser {
                
                DataService.ds.REF_USERS.child(user.uid).updateChildValues(["language": Localize.currentLanguage()], withCompletionBlock: { (error, ref) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        self.showAlert(message: error.localizedDescription)
                        return
                    } else {
                        self.viewDidLoad()
                        self.showAlert(message: "Language is changed")
                    }
                })
            }
        }
    }
    
    func changePassword() {
        
        guard let currentPassword = currentPasswordTextField.text, let newPassword = newPasswordTextField.text else {
            return
        }
        
        guard !currentPassword.isEmpty else {
            showAlert(message: "Current Password is Invalid".localized())
            return
        }
        
        guard !newPassword.isEmpty && newPassword.characters.count >= 6 else {
            showAlert(message: "New Password must be at least 6 characters".localized())
            return
        }
        
        // get user
        guard let user = Auth.auth().currentUser, let email = user.email else {
            return
        }
        
//        var credential: AuthCredential
        
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

        
        user.reauthenticate(with: credential, completion: { (error) in
            if let error = error {
                print(error.localizedDescription)
                self.showAlert(message: "Wrong password".localized())
                return
            }
            user.updatePassword(to: newPassword, completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.showAlert(message: "Could not change password".localized())
                    return
                }
                
                // success
                
                self.currentPasswordTextField.text = ""
                self.newPasswordTextField.text = ""
                
                self.showAlert(message: "Password is changed".localized())
            })
//            user.updatePassword(newPassword, completion: { (error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                    self.showAlert(message: "Could not change password".localized())
//                    return
//                }
//                
//                // success
//                
//                self.currentPasswordTextField.text = ""
//                self.newPasswordTextField.text = ""
//                
//                self.showAlert(message: "Password is changed".localized())
//            })
        })
    }
    
    func getAge(birthdate: Date) -> Int? {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year], from: birthdate)
        let currentDateComponents = calendar.dateComponents([.year], from: Date())
        
        if let currentYear = currentDateComponents.year, let yearOfBirth = components.year {
            return currentYear - yearOfBirth
        }
        return nil
    }
    
    func getDateString(date: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        return dateFormater.string(from: date)
    }
    
    func getDateFrom(string: String) -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        return dateFormater.date(from: string)
    }
    
    // get height (inches) from feetTextField and inchesTextField
    func getHeightFromTextFields() -> Double? {
        var height = 0.0 // inch unit
        if let feetText = heightFeetTextField.text, let feet = Double(feetText) {
            height = feet * 12
        }
        if let inchesText = heightInchesTextField.text, let inches = Double(inchesText) {
            height = height + inches
        }
        return height
    }
    
    // inches -> feet + inches
    func getHeight(height: Double) -> (feet: Double, inches: Double) {
        var feet = 0.0
        var inches = 0.0
        if height >= 12 {
            feet = Double(Int(height) / Int(12))
        }
        inches = height - (feet * 12)
        return (feet, inches)
    }
}

// MARK: - SettingsVC: UITextFieldDelegate

extension SettingsVC: UITextFieldDelegate {
    
    func doneClick() {
        view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == sexTextField {
            
            view.endEditing(true)
            
            var initialSelection = 0
            if let isMale = sexTextField.text, isMale != "Male".localized() {
                initialSelection = 1
            }
            
            let picker = ActionSheetStringPicker(title: "Sex".localized(), rows: ["Male".localized(), "Female".localized()], initialSelection: initialSelection, doneBlock: { (picker, values, indexes) in
                textField.text = indexes as? String
                return
            }, cancel: { (picker) in
                return
            }, origin: textField)
            
            // done - cancel
            picker?.setDoneButton(UIBarButtonItem(title: "Done".localized(), style: .done, target: nil, action: nil))
            picker?.setCancelButton(UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: nil, action: nil))
            
            picker?.show()
            
            return false
        } else if textField == birthdateTextField {
            
            view.endEditing(true)
            
            var date = Date()
            if let birthdateText = birthdateTextField.text, let birthdate = getDateFrom(string: birthdateText) {
                date = birthdate
            }
            
            let picker = ActionSheetDatePicker(title: "Birth date".localized(), datePickerMode: .date, selectedDate: date, doneBlock: { (picker, values, indexes) in
                
                if let date = values as? Date {
                    textField.text = self.getDateString(date: date)
                    
                    if let age = self.getAge(birthdate: date) {
                        self.ageTextField.text = "\(age)"
                    } else {
                        self.ageTextField.text = ""
                    }
                }
                return
            }, cancel: { (picker) in
                return
            }, origin: textField)
            
            // done - cancel
            picker?.setDoneButton(UIBarButtonItem(title: "Done".localized(), style: .done, target: nil, action: nil))
            picker?.setCancelButton(UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: nil, action: nil))
            
            picker?.show()
            
            return false
        } else if textField == currentLanguageTextField {
            
            view.endEditing(true)
            
            let arr = Array(languages.values).sorted()
            
            var initialSelection = 0
            
            if let language = currentLanguageTextField.text {
                for (index, value) in arr.enumerated() {
                    if value == language {
                        initialSelection = index
                        break
                    }
                }
            }
            
            let picker = ActionSheetStringPicker(title: "Language".localized(), rows: arr, initialSelection: initialSelection, doneBlock: { (picker, values, indexes) in
                textField.text = indexes as? String
                return
            }, cancel: { (picker) in
                return
            }, origin: textField)
            
            // done - cancel
            picker?.setDoneButton(UIBarButtonItem(title: "Done".localized(), style: .done, target: nil, action: nil))
            picker?.setCancelButton(UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: nil, action: nil))
            
            picker?.show()
            
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func keyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillHide(notification: Notification) {
        scrollViewBottomConstraint.constant = 0.0
    }
    
    func keyboardWillChangeFrame(notification: Notification) {
        scrollViewBottomConstraint.constant = keyboardHeight(notification: notification)
    }
}

// MARK: - SettingsViewController

extension SettingsVC{
    
    func subscribeToNotification(notification: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
