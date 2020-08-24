//
//  UploadProofTableViewCell.swift
//  Cricshot
//
//  Created by Cricshot on 04/04/19.
//  Copyright © 2019 SVAP Infotech. All rights reserved.
//

import UIKit

class UploadProofTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var imgPic: UIImageView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewDotted: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp();
    }
    
    func setUp() {
        self.lblHeading.font = UIFont(name: font_medium, size: 12);
        self.btnUpload.titleLabel?.font = UIFont(name: font_bold, size: 13);
        self.viewParent.backgroundColor = APPCOLOR.TextWhiteColor;
        self.lblHeading.textColor = APPCOLOR.TextBlackColor;
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
