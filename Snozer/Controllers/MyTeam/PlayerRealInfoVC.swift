//
//  PlayerRealInfoVC.swift
//  Snozer
//
//  Created by Admin on 10/12/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class PlayerRealInfoVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	var arrPlayers : [PlayerStatsDto] = [];
    @IBOutlet weak var collPlayerInfo: UICollectionView!
    @IBOutlet weak var vwHeader: UIView!
    var headerView : NavHeaderView?
    var isDreamTeam = false;
    var matchId = "";
    var customerTeamId = "";
    var playerId = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
	
        self.setHeaderView();
        self.collPlayerInfo.registerCollectionViewCellWithNib(nibName: "PlayerRealInfoCell");
        self.callApiForPlayerStats();
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "PLAYERS STATS");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        
    }
    
    func callApiForPlayerStats() {
        
        var api = "";
        if matchId == ""{
            self.matchId = appdelegate.SingleMatchInfo.matchId
        }
        if isDreamTeam{
            api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.DreamTeamStats + "/" + self.matchId;
        }else{
            api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.CustomerTeamStats + "/" + self.customerTeamId;
        }
        
        HomeService.GetCustomerTeamStats(_apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                self.arrPlayers = response;
                self.collPlayerInfo.delegate = self;
                self.collPlayerInfo.dataSource = self;
                self.collPlayerInfo.reloadData();
                if self.playerId != ""{
                    if let index = self.arrPlayers.firstIndex(where: {$0.playerId == self.playerId}){
                        self.collPlayerInfo.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false);
                    }
                }
                
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
    
}

extension PlayerRealInfoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPlayers.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerRealInfoCell", for: indexPath) as! PlayerRealInfoCell;
        cell.playerSkills = arrPlayers[indexPath.row];
        cell.arrPlayerSkills = arrPlayers[indexPath.row].playerEvents;
        cell.setCellData();
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 80);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
