//
//  SiteListCell.swift
//  Trial Finder
//
//  Created by Milan Garg on 12/5/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit

class SiteListCell: UITableViewCell {

    @IBOutlet weak var siteName: UILabel!
    @IBOutlet weak var lastmessage: UILabel!
    @IBOutlet weak var lbStoreName: UILabel!
    @IBOutlet weak var newMessageView: UIView!
    
    var site: Site!
    
    func configureCell(site: Site) {
        self.site = site
        print("site Name\(site.name)")
        self.siteName.text = site.name
          }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
