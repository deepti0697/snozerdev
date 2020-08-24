//
//  PlayerTypeCell.swift
//  Cricshot
//
//  Created by apple on 04/02/19.
//  Copyright © 2019 Cricshot. All rights reserved.
//

import UIKit

class PlayerTypeCell: UITableViewCell {
    
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var playerCollection: UICollectionView!
    let str_resueIdentifier = String(describing: type(of: PlayerLayoutCollectionViewCell()))
    var arrTeams : [PlayerData] = [];
    var isFromCreateteam = 1
    var isTopTeam = false;
    var team1Id : String = "";
    var matchId = "";
    var customerTeamID = "";
    var playerId = "";
    var isShowPoints = false;
    var parentVC: UIViewController?
    var superParentVC: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblPlayerName.font = UIFont(name: font_bold, size: 14);
        self.lblPlayerName.textColor = APPCOLOR.TextWhiteColor.withAlphaComponent(0.5);
        self.playerCollection.dataSource = self
        self.playerCollection.delegate = self
        self.playerCollection.register(UINib(nibName: str_resueIdentifier, bundle: nil), forCellWithReuseIdentifier: str_resueIdentifier)
        self.playerCollection.showsVerticalScrollIndicator = false
        self.playerCollection.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension PlayerTypeCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionView Data Source Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTeams.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : PlayerLayoutCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerLayoutCollectionViewCell", for: indexPath) as! PlayerLayoutCollectionViewCell
        let dict = self.arrTeams[indexPath.row];
        
        cell.configureLayoutScreen(dict)
        if self.isShowPoints {
            cell.lblPoints?.text = String("\((Double(dict.points)! * dict.playerMultiplier).clean) pts")
        } else {
            cell.lblPoints?.text = String("\(dict.credits) cr")
        }
        
        if team1Id == dict.teamId {
            cell.lbl_playerName.backgroundColor = APPCOLOR.redCustom
            cell.lbl_playerName.textColor = APPCOLOR.TextWhiteColor
        } else {
            cell.lbl_playerName.backgroundColor = APPCOLOR.TextBlackColor
            cell.lbl_playerName.textColor = APPCOLOR.TextWhiteColor
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = self.arrTeams[indexPath.row];
        if self.isFromCreateteam != 1  {
            if appdelegate.SingleMatchInfo == nil {
                parentVC?.dismiss(animated: true, completion: nil);
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PlayerRealInfoVC") as! PlayerRealInfoVC
                vc.isDreamTeam = isTopTeam;
                vc.matchId = self.matchId;
                vc.customerTeamId = self.customerTeamID
                
//                vc.matchId = dict.matchDetailId
                vc.playerId = dict.playerId
                superParentVC?.navigationController?.pushViewController(vc, animated: true)
            } else {
                if appdelegate.SingleMatchInfo.matchProgress == "F" {
                    parentVC?.view.showToast(message: "Patience builds Champions! For now, view all player points after the match starts.")
                } else {
                    parentVC?.dismiss(animated: true, completion: nil);
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PlayerRealInfoVC") as! PlayerRealInfoVC
                    vc.isDreamTeam = isTopTeam;
                    vc.matchId = self.matchId;
                    vc.customerTeamId = self.customerTeamID
                    vc.playerId = dict.playerId
                    superParentVC?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            
        }
    }
    
    // MARK: - UICollectionView Data Source Functions
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = UIScreen.main.bounds.height/5
        return CGSize(width: UIScreen.main.bounds.width/5  , height: height - 21 )
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCell = self.arrTeams.count
        //  let numberOfCells = floor(self.view.frame.size.width / cellWidth)
        let edgeInsets = (UIScreen.main.bounds.width - (CGFloat(totalCell) * (UIScreen.main.bounds.width/5)))
        
        return UIEdgeInsets(top: 0, left: edgeInsets/2, bottom: 0, right: edgeInsets/2)
    }
}
