//
//  MatchCenterHeaderCell.swift
//  Cricshot
//
//  Created by Cricshot#1 on 03/01/19.
//  Copyright © 2019 Cricshot. All rights reserved.
//

import UIKit

class MatchCenterHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var btnFixture: UIButton!
    @IBOutlet weak var btnLive: UIButton!
    @IBOutlet weak var btnCompleted: UIButton!
    
    @IBOutlet var lblText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }
    
    func setUp() {
        self.btnLive.titleLabel?.font = UIFont(name: font_medium, size: 13)
        self.btnFixture.titleLabel?.font = UIFont(name: font_medium, size: 13)
        self.btnCompleted.titleLabel?.font = UIFont(name: font_medium, size: 13)
        self.lblText.font = UIFont(name: font_bold, size: 15);
        self.lblText.textColor = APPCOLOR.TextBlackColor;
        
        btnLive.setshadow(cornerR: 4, shadowC: .darkGray, shadowO: 0.3, shadowR: 2, shadowOffset: CGSize(width: -1, height: 1));
        btnFixture.setshadow(cornerR: 4, shadowC: .darkGray, shadowO: 0.3, shadowR: 2, shadowOffset: CGSize(width: -1, height: 1));
        btnCompleted.setshadow(cornerR: 4, shadowC: .darkGray, shadowO: 0.3, shadowR: 2, shadowOffset: CGSize(width: -1, height: 1));
        
    }
    
}
