//
//  UIViewController+CustomMethods.swift
//  BookingApp
//
//  Created by Milan Garg on 10/20/16.
//  Copyright © 2016 knowledgeops. All rights reserved.
//

import UIKit

extension UIViewController
{

     func hideKeyboardOnScreenTap()
    {
        let tapAnyWhere: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tapAnyWhere)
    }

    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    // MARK : Extra methods
    
    /** extract all the textfield from view **/
    func getTextfield(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfield(view: subview)
            }
        }
        return results
    }
    
    /** Showing alert with message **/
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /** Toggle activity indicator **/
    
    func showActivityIndicator(isShow: Bool, activityIndicatorView: UIActivityIndicatorView)
    {
        activityIndicatorView.center = self.view.center
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = .gray
        
        if isShow
        {
            view.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
        }
        else{
            activityIndicatorView.stopAnimating()
            view.willRemoveSubview(activityIndicatorView)
        }
    }
    
    func setTabBarVisible(visible: Bool, animated: Bool) {
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (isTabBarVisible == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration: TimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animate(withDuration: duration) {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                return
            }
        }
    }
    
    var isTabBarVisible: Bool {
        return (self.tabBarController?.tabBar.frame.origin.y ?? 0) < self.view.frame.maxY
    }
 }
