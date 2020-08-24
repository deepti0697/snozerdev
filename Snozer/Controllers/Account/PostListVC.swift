//
//  PostListVC.swift
//  Snozer
//
//  Created by Admin on 05/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class PostListVC: ViewController {
    
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var lblNoDataTopStmt: UILabel!
    @IBOutlet weak var vwNoData: UIView!
    @IBOutlet weak var lblNoDataBottomStmt: UILabel!
    
    var arrReactions : [CommonDto] = [];
    var arrPost: [PostShareDto] = [];
    @IBOutlet weak var tblPost: UITableView!
    @IBOutlet weak var vwHeader: UIView!
    var headerView : NavHeaderView?
    var userId = "";
    var comeFrom = "";
    var refreshControl = UIRefreshControl()
    var loadPage = 1;
    var isNoMore = false;
	var headerTitle = "MY POST";
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setHeaderView()
        tblPost.registerTableViewCellWithNib(nibName: "PostTCell");
        tblPost.estimatedRowHeight = 320;
        tblPost.rowHeight = UITableView.automaticDimension;
        tblPost.tableFooterView = UIView();
		tblPost.backgroundColor = .white;
        ////--Pull to Refresh---///
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(RefreshData(refreshControl:)), for: .valueChanged)
        tblPost.addSubview(refreshControl)
        self.callApiForPost();
        self.callApiForReactions();
    }
    
    @objc func RefreshData(refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: .background).async {
            self.loadPage = 1;
            self.callApiForPost(page: self.loadPage)
        }
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        if comeFrom == "ShareTeam"{
            headerView?.isCustomBack = true;
        }
        headerView?.setHeaderinfo(title: headerTitle);
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.backAction = {
		if let arr = self.navigationController?.viewControllers.filter({$0.isKind(of: MyTeamVC.self)}), arr.count > 0{
			self.navigationController!.popToViewController(arr.first!, animated: true)
		}else{
			self.navigationController?.popViewController(animated: true);
		}
        }
    }
    
    func callApiForPost(page: Int = 1) {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.PostList
        HomeService.getPostList(_apiName: api, params: ["customer_id":userId]) { (flag, response, msg) in
            self.vwNoData.isHidden = true
            if flag{
                if page == 1{
                    self.isNoMore = false;
                    self.arrPost = response;
                }else{
                    if response.count == 0{
                        self.isNoMore = true;
                    }else{
                        self.arrPost.append(contentsOf: response);
                    }
                }
                self.tblPost.reloadData();
            }else{
                self.isNoMore = true;
                self.view.showToast(message: msg);
            }
            
            if self.arrPost.count == 0{
                self.vwNoData.isHidden = false;
		self.lblNoDataTopStmt.text = "Hi,  \(appdelegate.objAccountInfo?.firstname ?? "") you haven't posted anything yet.";
		if self.headerTitle != "MY POST"{
			self.lblNoDataTopStmt.text = "\(self.headerTitle) hasn't posted anything yet.";
		}
                self.lblNoDataBottomStmt.text = "";
                if self.userId == appdelegate.objAccountInfo?.id{
                    self.lblNoDataBottomStmt.text = "Share your teams and contests with your followers!";
                }
            }
        }
        
        
        
    }
    
    func callApiForReactions() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.ReactionList
        HomeService.GetReactionList(_apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                self.arrReactions = response;
            }else{
                self.view.showToast(message: msg);
            }
        }
        
        
        
    }
    
    @objc func actionForReactions(sender : UIButton){
        let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "ReactionListVC") as! ReactionListVC;
        vc.arrReactions = self.arrReactions;
        let postId = arrPost[sender.tag].id;
        vc.selectReactionId = { [weak self](reactionId) in
            self?.callApiForPostReactionWithPost(postId, reactionId: reactionId)
        }
        
        vc.modalPresentationStyle = .overCurrentContext;
        self.present(vc, animated: true, completion: nil);
    }
    
    @objc func actionForAllUserReactions(sender : UIButton){
        let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "AllUserReactionsVC") as! AllUserReactionsVC;
        vc.arrReactions = arrPost[sender.tag].reactions;
        vc.reactionId = "-1";
        vc.postId = arrPost[sender.tag].id;
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func callApiForPostReactionWithPost(_ postId : String, reactionId: String) {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.PostReact
        HomeService.postReact(_apiName: api, params: ["post_id":postId, "reaction_id": reactionId]) { (flag, msg) in
            if flag{
                self.callApiForPost();
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
}


extension PostListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPost.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTCell") as! PostTCell
        cell.setCellInfo(postData: arrPost[indexPath.row]);
        cell.btnRreaction.addTarget(self, action: #selector(actionForReactions(sender:)), for: .touchUpInside);
        cell.btnRreaction.tag = indexPath.row;
        cell.btnUserReactions.addTarget(self, action: #selector(actionForAllUserReactions(sender:)), for: .touchUpInside);
        cell.btnUserReactions.tag = indexPath.row;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamPreviewController") as! TeamPreviewController
        vc.selectedTeamID = arrPost[indexPath.row].teamId;
        let sportType = arrPost[indexPath.row].sport?.sportId ?? "0";
        vc.matchid = arrPost[indexPath.row].matchId;
        if let info = arrPost[indexPath.row].userDetail{
            vc.strTeamName = "\(info.teamName!) (T\(arrPost[indexPath.row].postTeam?.name ?? ""))".uppercased();
        }
        vc.parentVC = self;
        vc.sportsType = sportType
        vc.matchUrl = sportType == kCricket ? APPURL.CricketUrl : (sportType == kFootball ? APPURL.FootBallUrl : APPURL.KabaddiUrl)
        vc.modalPresentationStyle = .overCurrentContext;
        self.present(vc, animated: true, completion: nil);
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let lastElement = arrPost.count - 1
//        if indexPath.row == lastElement && !isNoMore{
//            loadPage = loadPage + 1
//            self.callApiForPost(page: loadPage);
//        }
//    }
    
}
