//
//  cellCashContestEarnings.swift
//  Snozer
//
//  Created by Admin on 07/03/20.
//  Copyright © 2020 SynarionItSolutions. All rights reserved.
//

import UIKit

class cellCashContestEarnings: UITableViewCell {

    @IBOutlet weak var lblCommision: UILabel!
       @IBOutlet weak var lblEntryFee: UILabel!
       @IBOutlet weak var lblDescription: UILabel!
       @IBOutlet weak var lblDate: UILabel!
       @IBOutlet weak var lblMatchVs: UILabel!
       @IBOutlet weak var lblearning: UILabel!
       @IBOutlet weak var imgUser: UIImageView!
       @IBOutlet weak var lblTeamName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpData(data : UserReferDto) {
        
        self.imgUser.sd_setImage(with:  URL.init(string: data.image),placeholderImage: UIImage.init(named: "user_icon"))
        self.lblTeamName.text = data.teamName
        self.lblearning.text = rupeeSymbol + " " + Float(data.amount)!.clean;
        lblCommision.text = Float(data.commission)!.clean + "%";
        if(data.entry_fees.count > 0 && data.entry_fees != "null")
        {
            lblEntryFee.text = rupeeSymbol + " " + Float(data.entry_fees)!.clean;
        }
        
        lblDate.text = Double(data.match_date)?.getDate("dd-MM-yyyy")
        lblMatchVs.text = data.match_name
        lblDescription.text = data.contest_category
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
