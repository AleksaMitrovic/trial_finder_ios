//
//  SentMessageCellTableViewCell.swift
//  Trial Finder
//
//  Created by Milan Garg on 12/12/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit

class SentMessageCell: UITableViewCell {
    
     @IBOutlet weak var sentMessageLabel: UILabel!
    @IBOutlet weak var sentMessageTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.sentMessageLabel.clipsToBounds = true
        self.sentMessageLabel.layer.cornerRadius = 6.0
        //self.incomingMessageLabel.layer.borderColor = UIColor.lightGray.cgColor
        //self.incomingMessageLabel.layer.borderWidth = 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
