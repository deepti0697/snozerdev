//
//  ContestDetailCompletedCell.swift
//  Cricshot
//
//  Created by Rampratap on 08/01/19.
//  Copyright © 2019 Cricshot. All rights reserved.
//

import UIKit

class ContestDetailCompletedCell: UITableViewCell {
    @IBOutlet var lblTotalWinning : UILabel?
    @IBOutlet var lblTotalWinners : UILabel?
    @IBOutlet var lblEntryFee : UILabel?
    
    @IBOutlet weak var lblPrizePoolStmt: UILabel!
    @IBOutlet var btnWinningBreakup : UIButton?
    @IBOutlet weak var lblEntryStmt: UILabel!
    
    @IBOutlet weak var lblWinnerStmt: UILabel!
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var imgArrow: UIImageView!
    var parentVC : UIViewController?
    @IBOutlet weak var imgDiscount: UIImageView!
    @IBOutlet weak var vwDiscount: UIView!
    @IBOutlet weak var lblDiscount: UILabel!
    var contestInfo : ContestPool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }
    
    func setUp()  {
        self.vwContainer.backgroundColor = whiteColor;
        
        self.vwContainer.setshadow(cornerR: 6, shadowC: .black, shadowO: 0.3, shadowR: 2, shadowOffset: CGSize(width: 1, height: 3));
        
        self.lblPrizePoolStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblWinnerStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblEntryStmt.textColor = APPCOLOR.TextBlackColor;
        
        self.lblTotalWinning?.textColor = APPCOLOR.greenCustom;
        self.lblEntryFee?.textColor = APPCOLOR.TextWhiteColor;
        self.lblEntryFee?.backgroundColor = APPCOLOR.redCustom;
        self.lblTotalWinners?.textColor = APPCOLOR.redCustom;
        self.imgArrow.tintColor = APPCOLOR.redCustom;
        
        
        self.lblTotalWinning?.font = UIFont(name: font_bold, size: 10);
        self.lblEntryFee?.font = UIFont(name: font_reguler, size: 10);
        self.lblTotalWinners?.font = UIFont(name: font_bold, size: 10);
        
        self.lblPrizePoolStmt.font = UIFont(name: font_reguler, size: 10);
        self.lblWinnerStmt.font = UIFont(name: font_reguler, size: 10);
        self.lblEntryStmt.font = UIFont(name: font_reguler, size: 10);
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func actionForWinnerBrackUp(_ sender: Any) {
        if let model = self.contestInfo{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WinningBreakupsVC") as! WinningBreakupsVC;
            vc.contestId = model.id;
            vc.prizePool = model.totalPrice
            vc.modalPresentationStyle = .overCurrentContext;
            parentVC?.present(vc, animated: true, completion: nil);
        }
    }
    
    func configureLayoutScreen(_ contestData : ContestPool) -> Void {
        self.contestInfo = contestData;
        self.lblTotalWinning?.text = rupeeSymbol + " " + contestData.totalPrice
        self.lblTotalWinners?.text = contestData.totalWinners
        self.lblEntryFee?.text = rupeeSymbol + " " +  contestData.entryFees.clean;
        
        imgArrow.isHidden = false;
        btnWinningBreakup?.isHidden = false;
        if Int(contestData.totalWinners)! <= 1{
            imgArrow.isHidden = true;
            btnWinningBreakup?.isHidden = true;
        }
        
        
        if contestData.moreEntryFee > 0{
            vwDiscount.isHidden = false;
            imgDiscount.isHidden = false;
//            let discount = 100 - Double(contestData.moreEntryFee)!
//            let superPrice = (Double(contestData.entryFees)! * 100)/discount;
            self.lblDiscount.text = rupeeSymbol + " " + contestData.actualEntryFees.clean
            self.imgDiscount.sd_setImage(with:  URL.init(string: contestData.discountImage),placeholderImage: UIImage.init(named: "user_icon"))
        }else{
            vwDiscount.isHidden = true;
            imgDiscount.isHidden = true;
        }
    }
}
