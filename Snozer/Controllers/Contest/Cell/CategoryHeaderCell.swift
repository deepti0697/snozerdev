//
//  CategoryHeaderCell.swift
//  Cricshot
//
//  Created by Cricshot#1 on 06/01/19.
//  Copyright © 2019 Cricshot. All rights reserved.
//

import UIKit

class CategoryHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet var lblCategoryTitle : UILabel?
    @IBOutlet var lblCategoryDesc : UILabel?
    @IBOutlet var imgCategory : UIImageView?
    @IBOutlet var lblMoreContest : UILabel?
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet var bgView : UIView?
    @IBOutlet weak var imgDiscount: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp();
    }

    func setUp() {
        self.lblCategoryTitle?.font  = UIFont(name: font_bold, size: 14)
        self.lblCategoryDesc?.font  = UIFont(name: font_reguler, size: 12)
        
        self.lblCategoryTitle?.textColor = APPCOLOR.TextBlackColor;
        self.lblCategoryDesc?.textColor = APPCOLOR.TextBlackColor
        
        self.bgView?.backgroundColor = APPCOLOR.TextWhiteColor;
    }
  
}
