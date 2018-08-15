//
//  NameVC.swift
//  Trial Finder
//
//  Created by Milan Garg on 2/20/17.
//  Copyright © 2017 Iran Mateu. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class NameVC: UIViewController {
    @IBOutlet weak var firstNameTextField: BottomLineTextField!
    @IBAction func submitButton(_ sender: Any) {
        updateInfo()
    }
    @IBAction func back(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
         updateInfo()
    }

    @IBOutlet weak var errorLabel: UILabel!{
        didSet {
            errorLabel.text = ""
        }
    }

    @IBOutlet weak var lastNameTextField: BottomLineTextField!
    
    var name:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func getData() -> [String: Any] {
        var data: [String: Any] = [:]
        
        if let firstName = firstNameTextField.text {
            data["firstName"] = firstName
        }
        
        if let lastName = lastNameTextField.text {
            data["lastName"] = lastName
        }
        data["firstLogin"] = "yes"
        
        return data
    }
    
    func updateInfo() {
        errorLabel.text = ""
        
        if (!self.firstNameTextField.hasText || !self.lastNameTextField.hasText)
        {
            errorLabel.text = "Please enter name".uppercased()
        }
        else
        {
        
        let data = getData()
        
        if let user = Auth.auth().currentUser {
            DataService.ds.REF_USERS.child(user.uid).updateChildValues(data, withCompletionBlock: { (error, ref) in
                
                if let error = error {
                    print(error.localizedDescription)
                   // self.updateInfoMessageLabel.text = "Could not update information"
                    return
                }
                
               // self.name = self.firstNameTextField.text
                
                //let keychainName = KeychainWrapper.standard.set(self.name!, forKey: KEY_NAME)
                
                self.performSegue(withIdentifier: "goToFeed", sender: self)
                
               // self.updateInfoMessageLabel.text = "Information is changed".uppercased()
            })
        }
    }
}
    func changeColor(for textField: BottomLineTextField, withColor color: UIColor = UIColor.black) {
        textField.borderColor = color
        textField.textColor = color
        textField.setNeedsDisplay()
    }


}

extension NameVC: UITextFieldDelegate {
    
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

