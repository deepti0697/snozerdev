//
//  CreateTeamPlayerStatsCell.swift
//  Snozer
//
//  Created by Admin on 15/12/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class CreateTeamPlayerStatsCell: UITableViewCell {

    @IBOutlet weak var lblSelectedBy: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMatchName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data: PlayerStatsDto) {
        lblSelectedBy.text = data.selectedBy + " %"
        lblPoints.text = data.points;
        lblMatchName.text = data.matchName;
        lblDate.text = Double(data.matchDate)!.getDate("dd-MM-yyyy");
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
