//
//  SelectionTableViewCell.swift
//  Trial Finder
//
//  Created by Huynh Danh on 10/26/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageview: UIImageView! {
        didSet {
            let image = checkImageview.image?.withRenderingMode(.alwaysTemplate)
            checkImageview.image = image
        }
    }
}
