//
//  ForgotPasswordVC.swift
//  Trial Finder
//
//  Created by Huynh Danh on 10/26/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit
import Firebase
import Localize_Swift

class ForgotPasswordVC: UIViewController {
    
    var errorMessage: String! {
        didSet {
            errorLabel.text = errorMessage.uppercased()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            errorLabel.text = ""
        }
    }
    @IBOutlet weak var emailTextField: BottomLineTextField!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var resetButton: RoundedButton!
    @IBOutlet weak var backButton: UIButton!

    var hasReset = false
    @IBAction func back(_ sender: AnyObject) {
        goBack()
    }
    
    @IBAction func resetPassword(_ sender: AnyObject) {
        if hasReset {
            goBack()
            return
        }
        
        if let email = emailTextField.text, !email.isEmpty && email.contains("@") {
            reset(email: email)
            resetButton.isUserInteractionEnabled = false
        } else {
            changeColor(for: emailTextField, withColor: UIColor.red)
            errorMessage = "Email is invalid"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let backBt = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(back))
//        backBt.tintColor = UIColor.black
//        self.navigationItem.leftBarButtonItem = backBt
//        self.title = "Forgot Password".localized()
        
        let image = UIImage(named: "ic_back")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = UIColor.black
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setText()
    }
    
    func setText() {
        titleLabel.text = "Forgot Password".localized()
        emailTextField.placeholder = "Email address".localized()
        noteLabel.text = "An email will be sent to your email address".localized()
        resetButton.setTitle("Reset".localized(), for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    func changeColor(for textField: BottomLineTextField, withColor color: UIColor) {
        textField.borderColor = color
        textField.textColor = color
        textField.setNeedsDisplay()
    }
    
    func reset(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            self.resetButton.isUserInteractionEnabled = true
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.emailTextField.text = ""
            self.hasReset = true
            self.resetButton.setTitle("Go Back To App", for: .normal)
            self.errorMessage = "OK. Check your email"
        })
    }
}

extension ForgotPasswordVC: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        changeColor(for: emailTextField, withColor: UIColor.black)
        errorMessage = ""
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        changeColor(for: emailTextField, withColor: UIColor.black)
        errorMessage = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
