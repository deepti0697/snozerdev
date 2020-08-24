//
//  LeaderboardHeaderCell.swift
//  Cricshot
//
//  Created by Cricshot#1 on 10/01/19.
//  Copyright © 2019 Cricshot. All rights reserved.
//

import UIKit
import Alamofire

class LeaderboardHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var vwBeatTheExpert: UIView!
    @IBOutlet weak var lblDownloadStmt: UILabel!
    
    @IBOutlet weak var imgTrophyW: NSLayoutConstraint!
    
    @IBOutlet weak var imgTrophy: UIImageView!
    @IBOutlet weak var lblExpertRank: UILabel!
    @IBOutlet weak var lblExpertPoints: UILabel!
    @IBOutlet weak var lblExpertName: UILabel!
    @IBOutlet weak var imgExpert: UIImageView!
    @IBOutlet weak var vwExpert: UIView!
    @IBOutlet weak var lblRankStmt: UILabel!
    @IBOutlet weak var lblTeamNameStmt: UILabel!
    @IBOutlet weak var vwLower: UIView!
    @IBOutlet weak var lblLeaderBoardStmt: UILabel!
    @IBOutlet weak var lblHederPoints: UILabel!
    @IBOutlet weak var lbltotalTeams: UILabel!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var vwDisable: UIView!
    var parentVC : UIViewController?
    var contestInfo: ContestPool?
    var beatExpertD: ContestLeaderboardData?
    var matchDetail : HomeMatchList?;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.setUp();
    }
    
    func setUp() {

        self.vwLower.backgroundColor = APPCOLOR.redCustom;
        self.lblRankStmt.textColor = APPCOLOR.TextWhiteColor ;
        self.lblTeamNameStmt.textColor = APPCOLOR.TextWhiteColor;
        self.lblHederPoints.textColor = APPCOLOR.TextWhiteColor;
        self.lblLeaderBoardStmt.textColor = APPCOLOR.TextDarkGrayColor
//        self.btnDownload.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        self.lblDownloadStmt.textColor = APPCOLOR.TextGrayColor;
        self.lbltotalTeams.textColor = APPCOLOR.TextLightGrayColor;
        
        self.lblExpertRank.textColor = APPCOLOR.TextBlackColor;
        self.lblExpertPoints.textColor = APPCOLOR.TextGrayColor;
        self.lblExpertName.textColor = APPCOLOR.TextBlackColor;
        
        
//        self.btnDownload.backgroundColor = APPCOLOR.redCustom;
        self.lblLeaderBoardStmt.font = UIFont(name: font_medium, size: 14);
        self.lblRankStmt.font = UIFont(name: font_medium, size: 11);
        self.lblTeamNameStmt.font = UIFont(name: font_medium, size: 11);
        self.lblHederPoints.font = UIFont(name: font_medium, size: 11);
        self.lblDownloadStmt.font = UIFont(name: font_reguler, size: 11);
        self.lbltotalTeams.font = UIFont(name: font_reguler, size: 10);
        
        
        self.lblExpertName.font = UIFont(name: font_medium, size: 12);
        self.lblExpertPoints.font = UIFont(name: font_reguler, size: 11);
        self.lblExpertRank.font = UIFont(name: font_medium, size: 12);
        
//        self.btnDownload.titleLabel?.font = UIFont(name: font_reguler, size: 10);
        
        self.vwExpert.cornerRadius = 6;
        self.vwExpert.borderColor = APPCOLOR.BlueTintCustom;
        self.vwExpert.borderWidth = 1;
        self.imgExpert.cornerRadius = 20;
        
        
    }
    
    
    func setBeatExpertData(info : ContestLeaderboardData?) {
        if let data = info{
            self.beatExpertD = data;
            imgExpert.sd_setImage(with:  URL.init(string: data.image),placeholderImage: UIImage.init(named: "user_icon"))
            lblExpertName.text = data.customerTeamName + "(T\(data.teamName))";
            lblExpertPoints.text = Double(data.totalPoints)!  > 0 ? "Points - "  + data.totalPoints : "";
            lblExpertRank.text = Int(data.newRank)!  > 0 ? "#\(data.newRank)" : "";
            imgTrophyW.constant = 0;
            imgTrophy.isHidden = true;
            if Int(self.beatExpertD!.newRank)! == 1{
                imgTrophy.isHidden = false;
                imgTrophyW.constant = 20;
            }
        }
        
    }
    
    @IBAction func actionForBeatExpertTeamPreview(_ sender: Any) {
        if matchDetail != nil {
            if matchDetail!.matchProgress == "F"{
                self.parentVC?.view.showToast(message: "Hang on! You will be able to download Teams after the deadline.");
                return;
            }
            
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamPreviewController") as! TeamPreviewController
        vc.isExpertTeam = true;
        vc.strTeamRank = Int(self.beatExpertD!.newRank)!  > 0 ? "#\(self.beatExpertD!.newRank)" : "";
        vc.isShowPoints = true
        vc.selectedTeamID = self.beatExpertD!.teamId
        vc.sportsType = appdelegate.matchType;
        vc.matchUrl = appdelegate.matchTypeUrl;
        vc.strTeamName = self.beatExpertD!.customerTeamName + "(T\(self.beatExpertD!.teamName))";
        vc.parentVC = self.parentVC;
        vc.modalPresentationStyle = .overCurrentContext;
        self.parentVC?.present(vc, animated: true, completion: nil);
        
        
    }
    
    @IBAction func actionForDownload(_ sender: Any) {
        
        if matchDetail != nil {
            if matchDetail!.matchProgress == "F"{
                self.parentVC?.view.showToast(message: "Hang on! You will be able to download Teams after the deadline.");
                return;
            }
            
        }
        
        

        let strName = String(format: "contest_pdf%@_%@.pdf", contestInfo!.id,appdelegate.SingleMatchInfo.matchId)
        
        
        
        let fileUrl = self.getSaveFileUrl(fileName: strName)
        
        let destination1: DownloadRequest.Destination = { _, _ in
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
    
        // print(destination1)
        //get_match_contest_pdf/:match_contest_id/:match_unique_id
        let urls = String(format: "%@%@%@/%@/%@", APPURL.BaseURL,appdelegate.matchTypeUrl,APPURL.DownloadTeamPdf,appdelegate.SingleMatchInfo.matchId,contestInfo!.matchContestId)
    
        AF.download(
            
            URL(string: urls)!,
            
            method: .get,
            
            parameters: nil,
            
            encoding: URLEncoding.httpBody,
            
            headers: HTTPHeaders(MainService.setHeader()),
            
            to: destination1).downloadProgress(closure: { (progress) in
                
                print(progress.fractionCompleted)
                
            }).response(completionHandler: { (DefaultDownloadResponse) in
                
//                let vc = UIActivityViewController(activityItems: [fileUrl], applicationActivities: [])
//
//                self.parentVC?.present(vc, animated: true, completion: nil
                
                let activityVC = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
                activityVC.excludedActivityTypes = []
                if UIDevice.current.userInterfaceIdiom == .pad {
                    activityVC.popoverPresentationController?.sourceView = self.parentVC?.view
                    if #available(iOS 12.0, *) {
                        activityVC.popoverPresentationController?.sourceRect = (sender as AnyObject).frame
                    } else {
                        // Fallback on earlier versions
                    }
                }

                self.parentVC?.present(activityVC, animated: true, completion: nil)
                
                print("DefaultDownloadResponse \(DefaultDownloadResponse)")
                
            })
        
    }
    
    func getSaveFileUrl(fileName: String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print(documentsURL)
        let nameUrl = URL(string: fileName)
        let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)!)
        NSLog(fileURL.absoluteString)
        return fileURL;
    }
}
