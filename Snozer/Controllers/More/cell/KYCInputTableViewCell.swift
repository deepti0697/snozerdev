//
//  KYCInputTableViewCell.swift
//  Cricshot
//
//  Created by Cricshot on 04/04/19.
//  Copyright © 2019 SVAP Infotech. All rights reserved.
//

import UIKit

class KYCInputTableViewCell: UITableViewCell {

    @IBOutlet weak var txtInput: SkyFloatingLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }
    
    func setUp() {
        
        self.txtInput.placeholderColor = APPCOLOR.TextLightGrayColor;
        self.txtInput.textColor = APPCOLOR.TextBlackColor;
        self.txtInput.lineColor = APPCOLOR.TextLightGrayColor;
        self.txtInput.selectedTitleColor = APPCOLOR.redCustom;
        self.txtInput.selectedLineColor = APPCOLOR.TextBlackColor;
        self.txtInput.tintColor = APPCOLOR.TextBlackColor;
        self.txtInput.textColor = APPCOLOR.TextBlackColor;
        self.txtInput.font = UIFont(name: font_reguler, size: 11);
//      self.txtInput  txt?.placeholderColor = UIColor(red: 185.0/255, green: 185.0/255, blue: 185.0/255, alpha: 1)
        self.txtInput.placeholderFont = UIFont.init(name: font_reguler, size: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
