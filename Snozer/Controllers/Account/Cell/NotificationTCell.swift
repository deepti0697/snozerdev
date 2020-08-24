//
//  NotificationTCell.swift
//  Snozer
//
//  Created by Admin on 26/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class NotificationTCell: UITableViewCell {

	@IBOutlet weak var imgClock: UIImageView!
	@IBOutlet weak var imgNotificaiton: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }
    
    func setUp() {
        self.lblMsg.textColor = APPCOLOR.TextBlackColor;
        self.lblMsg.font = UIFont(name: font_reguler, size: 11);
        self.lblTitle.font = UIFont(name: font_medium, size: 14);
        self.lblTitle.textColor = APPCOLOR.redCustom;
        self.lblDate.textColor = APPCOLOR.TextLightGrayColor;
        self.lblDate.font = UIFont(name: font_reguler, size: 11);
//		if let myImage = UIImage(named: "clock_icon") {
//			let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
//			imgClock.image = tintableImage
//			imgClock.tintColor = .gray;
//		}
		let templateImage = imgClock.image?.withRenderingMode(.alwaysTemplate)
		imgClock.image = templateImage
		imgClock.tintColor = UIColor.gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
