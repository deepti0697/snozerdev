//
//  FollowTCell.swift
//  Snozer
//
//  Created by Admin on 07/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class FollowTCell: UITableViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    var customerInfo : CustomerInfoDto?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp();
    }
    
    func setUp() {
        self.lblTeamName.font = UIFont(name: font_reguler, size: 14);
        self.lblName.font = UIFont(name: font_bold, size: 14);
        self.btnFollow.backgroundColor = APPCOLOR.redCustom;
        self.btnFollow.titleLabel?.font = UIFont(name: font_bold, size: 14);
        self.lblTeamName.textColor = APPCOLOR.TextGrayColor;
        self.lblName.textColor = APPCOLOR.TextBlackColor;
        self.imgUser.cornerRadius = 25;
        
    }

    func cellSetup(info : CustomerInfoDto) {
        customerInfo = info;
        self.imgUser.sd_setImage(with:  URL.init(string: customerInfo!.image),placeholderImage: UIImage.init(named: "user_icon"))
        self.lblName.text = customerInfo!.firstname + " " + customerInfo!.lastname;
        self.lblTeamName.text = customerInfo!.teamName;
        self.btnFollow.setTitle(customerInfo!.isFollow == "N" ? "FOLLOW" : "UNFOLLOW", for: .normal);
        self.btnFollow.backgroundColor = customerInfo!.isFollow == "N" ? APPCOLOR.greenCustom : APPCOLOR.redCustom
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionForFollow(_ sender: Any) {
        let api = APPURL.BaseURL + APPURL.CricketUrl + APPURL.FollowNUnFollow;
        if customerInfo != nil{
            UserService.followAndUnfollow(api, ["following_id" : customerInfo!.id, "type" :  customerInfo?.isFollow == "N" ? "FOLLOW" : "UNFOLLOW"]) { (flag, respone, msg) in
                if flag{
                    self.customerInfo?.isFollow = self.customerInfo?.isFollow == "N" ? "Y" : "N"
                    self.cellSetup(info: self.customerInfo!);
                }
            }
        }        
    }
}
