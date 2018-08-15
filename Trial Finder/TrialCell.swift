//
//  TrialCell.swift
//  Trial Finder
//
//  Created by Iran Mateu on 10/13/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import FirebaseStorageUI

class TrialCell: UITableViewCell {
    
    @IBOutlet weak var conditionIcon: UIImageView! {
        didSet {
            layoutIfNeeded()
            conditionIcon.layer.cornerRadius = conditionIcon.frame.size.height / 2
            conditionIcon.layer.borderWidth = 1.0
            conditionIcon.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    @IBOutlet weak var siteName: UILabel!
    @IBOutlet weak var siteAddress: UILabel!
    @IBOutlet weak var studyName: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var trial: Trial!
    
    func configureCell(trial: Trial, img: UIImage? = nil) {
        self.trial = trial
        self.studyName.text = trial.studyName

        let ref = Storage.storage().reference(forURL: trial.conditionImageUrl)
        self.conditionIcon.sd_setImage(with: ref)
        
        if let site = trial.site {
            self.siteName.text = site.name
            self.siteAddress.text = site.address
            self.distanceLabel.text = site.distance == 0.0 ? "Distance updating.." : "\(String(format: "%.2f", site.distance / 1609.344)) Miles away"
        } else {
            self.siteName.text = ""
            self.siteAddress.text = ""
            self.distanceLabel.text = ""
        }
    }
}
