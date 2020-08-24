//
//  CashContestEarningVC.swift
//  Snozer
//
//  Created by Admin on 05/03/20.
//  Copyright © 2020 SynarionItSolutions. All rights reserved.
//

import UIKit

class CashContestEarningVC: UIViewController {

    var arrCashContest : [UserReferDto] = [];
    
    @IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var tblCashContestList: UITableView!
   
    var shareContent = "";
    var headerView : NavHeaderView?
    var referralData : ReferDataDto!
    var refDetail : ReferralDto?
    
    @IBOutlet weak var inviteImg: UIImageView!
    override func viewDidLoad() {
            super.viewDidLoad()
            self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
            self.tblCashContestList.registerTableViewCellWithNib(nibName: "cellCashContestEarnings");
            self.tblCashContestList.backgroundColor = .white;
            self.setHeaderView();
            self.callApiForCashContest();
        }
        func setHeaderView() {
            headerView = NavHeaderView.loadViewFromNib();
            headerView?.parentVC = self;
            headerView?.stckLeft.isHidden = true;
            vwHeader.addSubview(headerView!);
            headerView?.setHeaderinfo(title: "INVITE FRIENDS");
            headerView?.lblNotificationCount.isHidden = true;
            headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
            
        }
        
        func callApiForCashContest()  {
            UserService.getReferTeamDetailCash { (flag, response, msg) in
                if flag{
                    if let info = response{
                        self.refDetail = info;
                        self.arrCashContest = self.refDetail!.userReferData;
                         self.tblCashContestList.reloadData();
                        
                        if self.arrCashContest.count == 0
                        {
                            self.inviteImg.isHidden = false
                        }
                    }
                }
            }
        }
        
        
        @IBAction func inviteFriendTapped(_ sender: Any) {
            let items = [shareContent]
//            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
//            present(ac, animated: true)
            
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            activityVC.excludedActivityTypes = []
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityVC.popoverPresentationController?.sourceView = self.view
                if #available(iOS 12.0, *) {
                    activityVC.popoverPresentationController?.sourceRect = (sender as AnyObject).frame
                } else {
                    // Fallback on earlier versions
                }
            }
            present(activityVC, animated: true, completion: nil)
            
        }
       /* @IBAction func actionForInfo(_ sender: Any) {
            self.popupAlert(title: kAppName, message: "Cash bonus will be added to your Snozer account only once the winner has been declared for the matches your friends have joined cash contest in", actionTitles: ["OK"], actions: [{}]);
        }*/

    }

    extension CashContestEarningVC : UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrCashContest.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCashContestEarnings") as! cellCashContestEarnings;
            cell.setUpData(data: arrCashContest[indexPath.row]);
            return cell;
        }
    }


