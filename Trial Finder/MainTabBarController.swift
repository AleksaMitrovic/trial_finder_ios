//
//  MainTabBarViewController.swift
//  Trial Finder
//
//  Created by Mobytelab on 7/14/17.
//  Copyright © 2017 Iran Mateu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let selectedVC = tabBarController.selectedViewController, selectedVC == viewController {
            return false
        }
        return true
    }
    
    
}
