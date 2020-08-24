//
//  AllUserReactionsVC.swift
//  Snozer
//
//  Created by Admin on 21/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit
import ObjectMapper;
class AllUserReactionsVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	var arrReactions : [CommonDto] = [];
    var arrCustomerInfo : [CustomerInfoDto] = [];
    @IBOutlet weak var tblCustomers: UITableView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var collReacts: UICollectionView!
    @IBOutlet weak var vwHeader: UIView!
    var postId: String = ""
    var reactionId: String = "-1"
    var headerView : NavHeaderView?
    override func viewDidLoad() {
        super.viewDidLoad()
		self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setHeaderView();
        tblCustomers.registerTableViewCellWithNib(nibName: "FollowTCell");
        tblCustomers.tableFooterView = UIView();
		tblCustomers.backgroundColor = .white;
        self.callApiForPost()
    }
    
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "REACTIONS");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        
    }
    
    func callApiForPost() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.CustomerPostReaction
        HomeService.GetCustomersReactions(_apiName: api, params: ["post_id":postId, "reaction_id" : reactionId]) { (flag, response, msg) in
            if flag{
                self.arrCustomerInfo.removeAll();
                if let data = response{
                    for dict in data{
                        if let obj = Mapper<CustomerInfoDto>().map(JSON: dict["user_detail"] as! [String: Any]){
                            self.arrCustomerInfo.append(obj);
                        }
                    }
                    self.tblCustomers.reloadData()
                }
                self.lblHeading.text = self.arrCustomerInfo.count == 0 ? "Looks like no one has reacted yet" : "\(self.arrCustomerInfo.count) reactions";
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
}

extension AllUserReactionsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrReactions.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReactionCell", for: indexPath) as! ReactionCell        
        cell.vwLine.isHidden = reactionId != arrReactions[indexPath.row].id
        cell.imgReact.sd_setImage(with:  URL.init(string: arrReactions[indexPath.row].image),placeholderImage: UIImage.init(named: "user_icon"))
        if arrReactions[indexPath.row].id == "-1"{
            cell.imgReact.isHidden = true;
            cell.lblTitle.isHidden = false;
        }else{
            cell.imgReact.isHidden = false;
            cell.lblTitle.isHidden = true;
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width)/6, height: 60);
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reactionId = arrReactions[indexPath.row].id;
        collReacts.reloadData();
        callApiForPost();
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 0.0
    }
    
}


extension AllUserReactionsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCustomerInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowTCell") as! FollowTCell
        cell.btnFollow.isHidden = true;
        cell.lblName.text = arrCustomerInfo[indexPath.row].firstname + arrCustomerInfo[indexPath.row].lastname
        cell.lblTeamName.text = arrCustomerInfo[indexPath.row].teamName;
        cell.imgUser.sd_setImage(with:  URL.init(string: arrCustomerInfo[indexPath.row].image),placeholderImage: UIImage.init(named: "user_icon"))
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    
}
