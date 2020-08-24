//
//  InviteeFriendCell.swift
//  Snozer
//
//  Created by BHUVAN SHARMA on 02/02/20.
//  Copyright © 2020 SynarionItSolutions. All rights reserved.
//

import UIKit

class InviteeFriendCell: UITableViewCell {

	@IBOutlet weak var progressBar: GradientProgressBar!
	@IBOutlet weak var lblEarnAmount: UILabel!
	@IBOutlet weak var lblReceivedAmount: UILabel!
	@IBOutlet weak var lblName: UILabel!
	@IBOutlet weak var imgUser: UIImageView!
	override func awakeFromNib() {
        super.awakeFromNib()
	//self.progressBar.trackTintColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1);
	//self.progressBar.gradientColors = [APPCOLOR.redCustom.cgColor, APPCOLOR.redCustom.cgColor];
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func  setUpData(data : UserReferDto) {
		let total = Float(data.referralAmount) ?? 0
        let left = Float(data.receiveAmount) ?? 0
        
        if total > 0 && left > 0 {
            var progress = 0.0
            let FinalValue = CGFloat(left / total)
            if(FinalValue == 1.0)
            {
                progress = Double(1.0)
            }
            else
            {
                progress = Double(FinalValue)
            }
            
            progressBar.progress = Float(progress)
        }
        else
        {
            progressBar.progress = 0.0
        }
        
        self.progressBar.trackTintColor = UIColor(red: 216.0/255, green: 216.0/255, blue: 216.0/255, alpha: 1);
        self.progressBar?.gradientColors = [APPCOLOR.redCustom.cgColor, APPCOLOR.redCustom.cgColor]
        
		self.imgUser.sd_setImage(with:  URL.init(string: data.image),placeholderImage: UIImage.init(named: "user_icon"))
        
        let firstName = data.firstName;
        let lastName = data.lastName;
        var FinalName = "\(firstName) \(lastName)"
        FinalName = FinalName.uppercased();
        
		self.lblName.text = "\(FinalName)"
        
		self.lblReceivedAmount.text = rupeeSymbol  + " " + Float(data.receiveAmount)!.clean;
		self.lblEarnAmount.text = rupeeSymbol + " " + Float(data.referralAmount)!.clean;
	}
    
}
