//
//  WinningBreakupOptionTCell.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class WinningBreakupOptionTCell: UITableViewCell {

    @IBOutlet weak var tblWinnerOptions: UITableView!
    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var lblWinnerTitle: UILabel!
    var contestInfo : WinningBreakups!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tblWinnerOptions.registerTableViewCellWithNib(nibName: "PrivateWinningTCell");
		tblWinnerOptions.backgroundColor = .white;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func  setCellInfo(info : WinningBreakups) {
        self.contestInfo = info;
        self.lblWinnerTitle.text = info.totalWinners + " Winners"
        tblWinnerOptions.delegate = self;
        tblWinnerOptions.dataSource = self;
        tblWinnerOptions.reloadData();
    }
    
}

extension WinningBreakupOptionTCell: UITableViewDataSource, UITableViewDelegate{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contestInfo.contestJson!.perMinP.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateWinningTCell") as! PrivateWinningTCell;
           if self.contestInfo.contestJson?.perMinP[indexPath.row] == self.contestInfo.contestJson?.perMaxP[indexPath.row]{
               cell.lblRank.text = "Rank: \(self.contestInfo.contestJson?.perMinP[indexPath.row] ?? "1")"
           }else{
               cell.lblRank.text = "Rank: \(self.contestInfo.contestJson?.perMinP[indexPath.row] ?? "1") - \(self.contestInfo.contestJson?.perMaxP[indexPath.row] ?? "1")"
           }
           cell.lblPercentage.text = "\(self.contestInfo.contestJson?.perPercent[indexPath.row] ?? "0")%" 
           cell.lblPrizeAmount.text = rupeeSymbol + " " + "\((self.contestInfo.contestJson?.perPrice[indexPath.row] ?? 0))"
            cell.vwLine.isHidden = true
           return cell;
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 40;
       }
    
}
