//
//  LeaderBoardTCell.swift
//  Snozer
//
//  Created by Admin on 06/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class LeaderBoardTCell: UITableViewCell {

    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var imgTrophy: UIImageView!
    @IBOutlet weak var vwLine: UIView!
    var parentVC: UIViewController?
    var customerId = "0";
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp();
        let tap = UITapGestureRecognizer(target: self, action: #selector(redirectToCustomerDetail))
        tap.numberOfTapsRequired = 1;
        imgUser.isUserInteractionEnabled = true;
        imgUser.addGestureRecognizer(tap);
    }
    
    @objc func redirectToCustomerDetail() {
        if customerId != "0"{
            if customerId == appdelegate.objAccountInfo?.id{
                parentVC?.navigationController?.popViewController(animated: true);
            }else{
                let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "CustomerInfoVC") as! CustomerInfoVC
                vc.customerId = customerId;
                parentVC?.navigationController?.pushViewController(vc, animated: true);
            }
            
        }
    }
    
    func setUp() {
        self.lblRank.font = UIFont(name: font_reguler, size: 12);
        self.lblPoints.font = UIFont(name: font_reguler, size: 12);
        self.lbName.font = UIFont(name: font_reguler, size: 12);
        
        self.lbName.textColor = APPCOLOR.TextBlackColor;
        self.lblPoints.textColor = APPCOLOR.OrangeCustom;
        self.lblRank.textColor = APPCOLOR.TextBlackColor;
        self.imgTrophy.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
