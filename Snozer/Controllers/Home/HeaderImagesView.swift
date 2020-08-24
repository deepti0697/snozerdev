//
//  HeaderImagesView.swift
//  Snozer
//
//  Created by Admin on 03/10/19.
//  Copyright © 2019 Calieo Technologies.. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import Alamofire


class HeaderImagesView: UIView , UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
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
        self.collOfferImage.dataSource = self
        self.collOfferImage.delegate = self
        self.collOfferImage.register(UINib.init(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
    }
    
    //MARK: ScrollView Delegate

    
    //MARK: - Collection View Setup
    
    func setup() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        itemWidth =  UIScreen.main.bounds.width - collectionMargin * 2
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if UIDevice.current.userInterfaceIdiom == .pad {
            layout.itemSize = CGSize(width: itemWidth, height: 160)
        }
        else
        {
            layout.itemSize = CGSize(width: itemWidth, height: 95)
        }
        
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
//
//        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        self.collOfferImage!.collectionViewLayout = layout
        self.collOfferImage?.decelerationRate = UIScrollView.DecelerationRate.fast
        
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
