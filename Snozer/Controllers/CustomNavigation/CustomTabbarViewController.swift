//
//  CustomTabbarViewController.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//
//

import UIKit

class CustomTabbarViewController: UITabBarController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tabBar.tintColor = APPCOLOR.redCustom
        self.tabBar.barTintColor = .white;
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        self.tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: 0, bottom: 4, right: 0)
        
        
        
        
        for (index, bar) in self.tabBar.items?.enumerated() ?? [].enumerated() {
            
            switch index {
            case 0:
                bar.title = Utility.sharedInstance.iconsInfo?.tabHome?.name ?? "HOME";
            case 1:
                bar.title = Utility.sharedInstance.iconsInfo?.tabMyContest?.name ?? "MY MATCHES";
            case 2:
                bar.title = Utility.sharedInstance.iconsInfo?.tabFeeds?.name ?? "FEED";
            case 3:
                bar.title = Utility.sharedInstance.iconsInfo?.tabAccount?.name ?? "ACCOUNT";
            case 4:
                bar.title = Utility.sharedInstance.iconsInfo?.tabMore?.name ?? "MORE";
            default:
                print("nothing")
            }
            

//            if bar.title == "HOME"{
//                bar.image = UIImage(named: "Tabhome")!.withRenderingMode(.alwaysOriginal)
//                bar.selectedImage = UIImage(named: "TabhomeSelected")!.withRenderingMode(.alwaysOriginal)
//            } else if bar.title == "MY CONTEST"{
//                bar.image = UIImage(named: "Tabcontest")!.withRenderingMode(.alwaysOriginal)
//                bar.selectedImage = UIImage(named: "TabcontestSelected")!.withRenderingMode(.alwaysOriginal)
//            } else if bar.title == "ACCOUNT"{
//                bar.image = UIImage(named: "Tabuser")!.withRenderingMode(.alwaysOriginal)
//                bar.selectedImage = UIImage(named: "TabuserSelected")!.withRenderingMode(.alwaysOriginal)
//            } else if bar.title == "FEED"{
//                bar.image = UIImage(named: "Feed")!.withRenderingMode(.alwaysOriginal)
//                bar.selectedImage = UIImage(named: "feedSelected")!.withRenderingMode(.alwaysOriginal)
//            } else if bar.title == "MORE"{
//                bar.image = UIImage(named: "Tabmore")!.withRenderingMode(.alwaysOriginal)
//                bar.selectedImage = UIImage(named: "TabmoreSelected")!.withRenderingMode(.alwaysOriginal)
//            }
        }
    }

}
