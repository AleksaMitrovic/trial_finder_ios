//
//  DistanceTableViewCell.swift
//  Trial Finder
//
//  Created by Huynh Danh on 10/28/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit

protocol DistanceTableViewCellDelegate {
    func didSliderChangeValue(value: Float)
}

class DistanceTableViewCell: UITableViewCell {
    
    var delegate: DistanceTableViewCellDelegate?
    
    @IBOutlet weak var distanceSlider: UISlider! {
        didSet {
            distanceSlider.setThumbImage(UIImage(named: "slider-thumb")!, for: .normal)
        }
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        distanceSlider.value = round(sender.value)
    }
    
    @IBAction func didEndEditting(_ sender: UISlider) {
        delegate?.didSliderChangeValue(value: sender.value)
    }
}
