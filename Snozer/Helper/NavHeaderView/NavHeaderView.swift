//
//  NavHeaderView.swift
//  Snozer
//
//  Created by Admin on 05/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class NavHeaderView: UIView {

	@IBOutlet weak var imgWallet: UIImageView!
	@IBOutlet weak var layoutStckLeftC: NSLayoutConstraint!
	@IBOutlet weak var layoutStckRightC: NSLayoutConstraint!
	@IBOutlet weak var lblNotificationCount: UILabel!
    @IBOutlet weak var vwNotification: UIView!
    @IBOutlet weak var stckLeft: UIStackView!
    var parentVC :  UIViewController?
    @IBOutlet weak var lblWalletAmount: UILabel!
    @IBOutlet weak var vwWallet: UIView!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    var backAction : () -> () = {}
    var isCustomBack = false;
    
    // MARK: - init methods
    
    override public init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func loadViewFromNib() -> NavHeaderView {
        let nib = UINib(nibName: "NavHeaderView", bundle: nil);
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! NavHeaderView
        return view
    }
    
    func setHeaderinfo(title : String) {
		let templateImage = imgWallet.image?.withRenderingMode(.alwaysTemplate)
		imgWallet.image = templateImage
		imgWallet.tintColor = APPCOLOR.redCustom
		
		
	layoutStckLeftC.constant = appdelegate.hasTopNotch ? 15 : 5
	layoutStckRightC.constant = appdelegate.hasTopNotch ? 15 : 5
        self.lblHeaderTitle.text = title;
        vwWallet.cornerRadius = 4;
        if let info = appdelegate.objAmountDetail{
            lblWalletAmount.text = String(format: "%.2f", info.totalAmount);
        }
        if let info = appdelegate.objAccountInfo{
            if Int(info.notificationCounter) ?? 0 > 0{
                self.lblNotificationCount.isHidden = false;
                self.lblNotificationCount.text = info.notificationCounter;
            }else{
                self.lblNotificationCount.isHidden = true;
            }
            
        }
    }
    
    func setWallet() {
        if let info = appdelegate.objAmountDetail{
            lblWalletAmount.text = String(format: "%.2f", info.totalAmount);
        }
        if let info = appdelegate.objAccountInfo{
            if Int(info.notificationCounter) ?? 0 > 0{
                self.lblNotificationCount.isHidden = false;
                self.lblNotificationCount.text = info.notificationCounter;
            }else{
                self.lblNotificationCount.isHidden = true;
            }
        }
    }
    
    @IBAction func actionForBack(_ sender: Any) {        
        if isCustomBack{
            backAction();
        }else{
            parentVC?.navigationController?.popViewController(animated: true);
        }
        
    }
    
    @IBAction func actionForNotification(_ sender: Any) {
        let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "NotificationVC");
        if let info = appdelegate.objAccountInfo{
            info.notificationCounter = "0"
        }
        parentVC?.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    @IBAction func actionForWalletRedirect(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "More", bundle: nil)
        let screen = mainStoryboard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
        screen.parentVC = self.parentVC;
        screen.transitioningDelegate = parentVC as! UIViewControllerTransitioningDelegate
        parentVC?.present(screen, animated: true, completion: nil)
    }
}
