//
//  AvtarSelectionVC.swift
//  Snozer
//
//  Created by Admin on 05/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class AvtarSelectionVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    var arrAvatars : [String] = [];
    var selectedUrl = "";
    @IBOutlet weak var btnAvatar: UIButton!
    @IBOutlet weak var collAvatar: UICollectionView!
    @IBOutlet weak var lblSelectAvatar: UILabel!
    var headerView : NavHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.callApiForSelectedAvatar();
        self.setUp();
        self.setHeaderView();
    }
    
    func setHeaderView() {
           headerView = NavHeaderView.loadViewFromNib();
           headerView?.parentVC = self;
           headerView?.stckLeft.isHidden = true;
           vwHeader.addSubview(headerView!);
           headerView?.setHeaderinfo(title: "CHANGE AVATAR");
            headerView?.lblNotificationCount.isHidden = true;
           headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
       }
    
    func setUp() {
        self.lblSelectAvatar.font = UIFont(name: font_medium, size: 16);
        self.lblSelectAvatar.textColor = APPCOLOR.redCustom;
        
        btnAvatar.backgroundColor = APPCOLOR.redCustom;
        btnAvatar.titleLabel?.font = UIFont(name: font_bold, size: 16);
        
        
        let cellSize = CGSize(width:(UIScreen.main.bounds.width - 20)/4 , height:(UIScreen.main.bounds.width - 20)/4)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        self.collAvatar.setCollectionViewLayout(layout, animated: true)
        
        
    }

    @IBAction func actionForAvatarUpdate(_ sender: Any) {
        self.setAvatar();
    }
    
    func callApiForSelectedAvatar() {
        UserService.getProfilePictures(params: [:]) { (flag,response, msg) in
            if flag{
                self.arrAvatars = response;
                self.collAvatar.reloadData();
            }
        }
    }
    
    func setAvatar() {
        if selectedUrl != ""{
            UserService.setProfilePicture(["image":selectedUrl]) { (flag, msg) in
                if flag{
                    self.navigationController?.popViewController(animated: true);
                }
                self.view.showToast(message: msg);
            }
        }else{
            self.view.showToast(message: "Please select avatar");
        }
    }
    
}


extension AvtarSelectionVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrAvatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath);
        let img = cell.viewWithTag(101) as! UIImageView
        let imgTick = cell.viewWithTag(102) as! UIImageView
        img.sd_setImage(with:  URL.init(string: arrAvatars[indexPath.row]),placeholderImage: UIImage.init(named: "dummyTeam"))
        img.borderColor = .clear;
        img.borderWidth = 0;
        imgTick.isHidden = true;
        if arrAvatars[indexPath.row] == selectedUrl{
            img.borderColor = APPCOLOR.greenCustom;
            img.borderWidth = 1;
            imgTick.isHidden = false;
        }
        return cell;
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 60, height: 60);
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collAvatar.cellForItem(at: indexPath){
            let img = cell.viewWithTag(101) as! UIImageView
            let imgTick = cell.viewWithTag(102) as! UIImageView
            img.borderColor = APPCOLOR.greenCustom;
            img.borderWidth = 1;
            imgTick.isHidden = false;
            selectedUrl = arrAvatars[indexPath.row];
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collAvatar.cellForItem(at: indexPath){
            let img = cell.viewWithTag(101) as! UIImageView
            let imgTick = cell.viewWithTag(102) as! UIImageView
            img.borderColor = .clear;
            img.borderWidth = 0;
            imgTick.isHidden = true;
        }
    }
}
