//
//  NoDataCell.swift
//  Cricshot
//
//  Created by Cricshot#1 on 25/01/19.
//  Copyright © 2019 Cricshot. All rights reserved.
//

import UIKit

class NoDataCell: UITableViewCell {

    @IBOutlet var lblNoData : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

struct NoDataAlert {

    static var NoMatchFound = String()

    static let NoContetsFound = "Right now no contest available for this match."
    static let NoNotificationFound = "No notification found"
    static let NoLeaderBoardFound = "No team joined this contest yet."

    static let NoTransactionFound = "No Transaction found for this category."
    static let NoJoinedContes = "No joined contest found"
    static let NoTeamFound = "Create your first team and join contest"
    static let NoSwitchTeamFound = "No switching team found!\n Create another team for switching."
    static let NoPlayerFound = "Player stats will update soon."
    
    
    static func getValueByTabAndSegment(tabIndex: Int,SegmentIndex: Int) {
        if tabIndex == 0 {
            if SegmentIndex == 101 {
                NoMatchFound = "Right now no matches available for this sports"
            } else if SegmentIndex == 102 {
                NoMatchFound = "Right now no live matches found"
            } else {
                 NoMatchFound = "Right now no result available"
            }
        } else {
            if SegmentIndex == 0 {
                 NoMatchFound = "You haven't joined any upcoming match contests"
            } else if SegmentIndex == 1 {
                NoMatchFound = "You haven't joined any live match contests"
            } else {
                NoMatchFound = "You haven't joined any contest in recently compleated matches "
            }
        }
    }
}
