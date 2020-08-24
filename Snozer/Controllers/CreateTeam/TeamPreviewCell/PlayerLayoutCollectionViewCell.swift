//
//  PlayerLayoutCollectionViewCell.swift
//  Snozer
//
//  Created by Admin on 18/12/18.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class PlayerLayoutCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl_playerName: UILabel!
    @IBOutlet weak var view_superview: UIView!
    @IBOutlet weak var img_playerTeam: UIImageView!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var lblPoints: UILabel!
    
    @IBOutlet weak var lblRole: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }
    
    func setUp() {
        self.lbl_playerName.font = UIFont(name: font_reguler, size: 10);
        self.lblPoints.font = UIFont(name: font_bold, size: 12);
        self.lblRole.font = UIFont(name: font_bold, size: 8);
        self.lblRole.backgroundColor = UIColor(red: 207.0/255, green: 207.0/255, blue: 207.0/255, alpha: 1);
        self.lblPoints.textColor = APPCOLOR.TextWhiteColor;
        self.lblRole.textColor = APPCOLOR.TextWhiteColor;
    }
    

    func configureLayoutScreen(_ Player : PlayerData) -> Void {
        
        self.lblRole.layer.cornerRadius = self.lblRole.frame.size.height/2
        self.lblRole.layer.masksToBounds = true
        self.lbl_playerName?.text = " \(Player.playerName) "
        self.lbl_playerName.layer.masksToBounds = true

        if Player.playerMultiplier == 2 {
          self.lblRole.text = "C"
            self.lblRole.backgroundColor = APPCOLOR.OrangeCustom;
          self.lblRole.isHidden = false
        } else if Player.playerMultiplier == 1.5 {
            self.lblRole.text = "VC"
            self.lblRole.backgroundColor = APPCOLOR.redCustom;
            self.lblRole.isHidden = false
        } else {
            self.lblRole.isHidden = true
        }
        
        self.img_playerTeam?.sd_setImage(with:  URL.init(string: Player.image),placeholderImage: UIImage.init(named: "dummyUser"))
        
    }
    
}
