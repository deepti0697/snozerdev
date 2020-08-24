//
//  OfferImageCell.swift
//  Cricshot
//
//  Created by Cricshot#1 on 03/01/19.
//  Copyright © 2019 Cricshot. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import Alamofire



class OfferImageCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    @IBOutlet var collOfferImage : UICollectionView!

    let collectionMargin = CGFloat(20)
    let itemSpacing = CGFloat(0)

    ///--Collection view space managing---///
    var itemWidth = CGFloat(0)
    var currentItem = 0
    
    //--Model object
    var  objHeaderImageList : HeaderModal!
    var  arrHeaderImageList = [HeaderModal]()
    var sportType = "C";


    override func awakeFromNib() {
        super.awakeFromNib()
//        self.setup();
        self.collOfferImage.dataSource = self
        self.collOfferImage.delegate = self
        self.collOfferImage.register(UINib.init(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state 
    }
    
    //MARK: - Collection View Delegate Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrHeaderImageList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath as IndexPath) as! ImageCollectionCell

        cell.imgOffer.backgroundColor = UIColor.lightGray
        cell.imgOffer.sd_setImage(with: URL.init(string: self.arrHeaderImageList[indexPath.row].image)) { (image, error, SDImageCacheType, url) in
            
            if image != nil {
                cell.imgOffer.backgroundColor = UIColor.clear
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: UIScreen.main.bounds.width, height: 180)
        }
        else
        {
            return CGSize(width: UIScreen.main.bounds.width, height: 120)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let objheader = self.arrHeaderImageList[indexPath.row]
        if objheader.type == "Refer"
        {
            let notificationDict:[String: Any] = ["type":"Refer" , "matchData" : ["":""]]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectHeaderImage"), object: nil, userInfo: notificationDict)
            
            
        }
        else if objheader.type == "2"
        {
            let notificationDict:[String: Any] = ["type":"2" , "matchData" : ["":""]]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectHeaderImage"), object: nil, userInfo: notificationDict)
            
        }
        else if objheader.type == "Web"
        {
            let notificationDict:[String: Any] = ["type":"Web" , "webUrl" : objheader.url ?? ""]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectHeaderImage"), object: nil, userInfo: notificationDict)
            
        }
        
        else if objheader.type == "AddCash"
        {
            let notificationDict:[String: Any] = ["type":"AddCash" , "matchData" : ["":""]]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectHeaderImage"), object: nil, userInfo: notificationDict)
            
        }
    }
 
    //MARK: API
    
    func GetHeaderImageList() {
        var apiUrl = APPURL.BaseURL + APPURL.CricketUrl + APPURL.GetHeaderImage;
        if sportType == "K"{
            apiUrl = APPURL.BaseURL + APPURL.KabaddiUrl + APPURL.GetHeaderImage;
        } else if sportType == "F"{
            apiUrl = APPURL.BaseURL + APPURL.FootBallUrl + APPURL.GetHeaderImage;
        }
        
        HomeService.getHeaderImageList(_apiName: apiUrl, params: [:]) { (flag, response, msg) in
            if flag{
                self.arrHeaderImageList.removeAll();
                self.arrHeaderImageList = response;
                self.collOfferImage.reloadData()
            }
        }
    }
}

