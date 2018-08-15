//
//  MessageCell.swift
//  Trial Finder
//
//  Created by Kunal Kumar on 12/8/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var incomingMessageLabel: UILabel!
    @IBOutlet weak var incomingNameLabel: UILabel!
    @IBOutlet weak var outgoingNameLabel: UILabel!
    @IBOutlet weak var incomingTimeLabel: UILabel!
    @IBOutlet weak var outgoingMessageLabel: UILabel!
    @IBOutlet weak var outgoingTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.incomingMessageLabel.clipsToBounds = true
        self.incomingMessageLabel.layer.cornerRadius = 6.0
        self.incomingMessageLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.incomingMessageLabel.layer.borderWidth = 2.0
    }
    
//    override func draw(_ rect: CGRect) {
//        let bubbleSpace = CGRect(x: self.incomingMessageLabel.frame.origin.x, y:incomingMessageLabel.frame.origin.x, width:self.incomingMessageLabel.bounds.width, height:self.incomingMessageLabel.bounds.height)
//
//        let bubblePath1 = UIBezierPath(roundedRect: bubbleSpace, byRoundingCorners:[UIRectCorner.topLeft , UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 5.0, height: 5.0))
//
//        
//        let bubblePath = UIBezierPath(roundedRect: bubbleSpace, cornerRadius: 20.0)
//        
//        UIColor.green.setStroke()
//        UIColor.green.setFill()
//        bubblePath.stroke()
//        bubblePath.fill()
//        
//        let triangleSpace = CGRect(x:0.0, y:self.bounds.height - 20, width:20, height:20.0)
//        let trianglePath = UIBezierPath()
//        let startPoint = CGPoint(x: 20.0, y: self.bounds.height - 40)
//        let tipPoint = CGPoint(x: 0.0, y: self.bounds.height - 30)
//        let endPoint = CGPoint(x: 20.0, y: self.bounds.height - 20)
//        trianglePath.move(to: startPoint)
//        trianglePath.addLine(to: tipPoint)
//        trianglePath.addLine(to: endPoint)
//        trianglePath.close()
//        UIColor.green.setStroke()
//        UIColor.green.setFill()
//        trianglePath.stroke()
//        trianglePath.fill()
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
