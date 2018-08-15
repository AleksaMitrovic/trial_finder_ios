//
//  mapsVC.swift
//  Trial Finder
//
//  Created by Huynh Danh on 10/22/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit
import CoreLocation
import Localize_Swift

class mapsVC: UIViewController {
    
    var location: CLLocation!
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func back(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let backBt = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(backClick))
        backBt.tintColor = UIColor.black //Changed By V.J white to black
        self.navigationItem.leftBarButtonItem = backBt
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setText()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black] //Changed By V.J
        if let location = location, let userLocation = AppState.userLocation {
            let urlString = "https://www.google.com/maps/dir/\(location.coordinate.latitude),\(location.coordinate.longitude)/\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)"
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                webView.loadRequest(request)
            }
        }
    }
    
    func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setText() {
        self.title = "Directions".localized()
    }
}
