//
//  BeatTheExpertJoinVC.swift
//  Snozer
//
//  Created by Admin on 29/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class BeatTheExpertJoinVC: UIViewController {

    var SuccessPrice: ((_ entryFee: String) -> Void)?
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var lblMultyStmt: UILabel!
    @IBOutlet weak var lblWinStmt: UILabel!
    var contestInfo : ContestPool!
    @IBOutlet weak var lblCalculatePrice: UILabel!
    @IBOutlet weak var lblEnterPrice: UILabel!
    @IBOutlet weak var txtPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var collSuggestionPrice: UICollectionView!
    @IBOutlet weak var lblChooseEntryStmt: UILabel!
    var finalPrice = "0"
    var selectedIndex = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp();
        self.setData();
        // Do any additional setup after loading the view.
    }
    
    func setUp() {
        self.lblChooseEntryStmt.textColor = APPCOLOR.TextWhiteColor;
        self.lblChooseEntryStmt.font = UIFont(name: font_reguler, size: 14);
        self.txtPrice.font = UIFont(name: font_reguler, size: 14);
        self.txtPrice.textColor = APPCOLOR.TextBlackColor;
        
        self.lblWinStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblMultyStmt.textColor = APPCOLOR.redCustom;
        self.lblEnterPrice.textColor = APPCOLOR.TextBlackColor;
        self.lblCalculatePrice.textColor = APPCOLOR.TextBlackColor;
        
        self.lblWinStmt.font = UIFont(name: font_reguler, size: 12);
        self.lblMultyStmt.font = UIFont(name: font_bold, size: 16);
        self.lblEnterPrice.font = UIFont(name: font_reguler, size: 12);
        self.lblCalculatePrice.font = UIFont(name: font_reguler, size: 12);
        txtPrice.delegate = self;
        txtPrice.placeholderColor = APPCOLOR.TextLightGrayColor;
        txtPrice.textColor = APPCOLOR.TextBlackColor;
        txtPrice.lineColor = APPCOLOR.TextLightGrayColor;
        txtPrice.selectedTitleColor = APPCOLOR.redCustom;
        txtPrice.selectedLineColor = APPCOLOR.TextBlackColor;
        txtPrice.tintColor = APPCOLOR.TextBlackColor;
        txtPrice.textColor = APPCOLOR.TextBlackColor;
        txtPrice.font = UIFont(name: font_reguler, size: 11);
//      txtPrice  txt?.placeholderColor = UIColor(red: 185.0/255, green: 185.0/255, blue: 185.0/255, alpha: 1)
        txtPrice.placeholderFont = UIFont.init(name: font_reguler, size: 12)
    }
    
    func setData() {
        collSuggestionPrice.delegate = self;
        collSuggestionPrice.dataSource = self;
        collSuggestionPrice.reloadData();
        
        txtPrice.text = rupeeSymbol + "\(contestInfo.entryFeesSuggest.first ?? 0)";
        lblEnterPrice.text = rupeeSymbol + "\(contestInfo.entryFeesSuggest.first ?? 0)";
        self.calCulateEntryFee();
    }
    
    func calCulateEntryFee() {
        let arr = txtPrice.text?.components(separatedBy: "₹")
        if (arr?.count)! > 1 {
            let strAmount = arr![1]
            if !strAmount.isEmpty {
                let amount = Double(strAmount) ?? .nan
                let finalAmount = amount * 3;
                self.finalPrice = strAmount;
                self.lblEnterPrice.text = rupeeSymbol + " " + String(amount) + " =";
                self.lblCalculatePrice.text = rupeeSymbol + " " + String(finalAmount);
                self.btnJoin.setTitle("JOIN WITH \(rupeeSymbol) \(strAmount)", for: .normal);
            }
        }
    }
    
    @IBAction func actionForJoinContest(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.SuccessPrice!(self.finalPrice);
        });
    }
    
    @IBAction func actionForDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
        appdelegate.isBeatExpert = false;
    }
}

extension BeatTheExpertJoinVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let arr = txtPrice.text?.components(separatedBy: "₹")
        if (arr?.count)! > 1 {
            let strAmount = arr![1]
            if !strAmount.isEmpty {
                if contestInfo.entryFeesSuggest.contains(Double(strAmount)!){
                    selectedIndex = contestInfo.entryFeesSuggest.firstIndex(of: Double(strAmount)!) ?? -1
                }else{
                    selectedIndex = -1;
                }
                self.calCulateEntryFee();
                collSuggestionPrice.reloadData();
                
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Not allowing user to delete the ruppee symbol.
        let protectedRange = NSMakeRange(0, 1)
        let intersection = NSIntersectionRange(protectedRange, range)
        if intersection.length > 0 {
            return false
        }
        
        // Maximum character 8. Not allowing to enter more than that.
        let maxLength = 8
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length > maxLength {
            return false
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contestInfo.entryFeesSuggest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionPriceCell", for: indexPath) as! SuggestionPriceCell;
        cell.lblPrice.font = UIFont(name: font_reguler, size: 14);
        cell.lblDiscountPrice.font = UIFont(name: font_reguler, size: 14);
        cell.lblPrice.textColor = APPCOLOR.TextBlackColor;
        cell.imgTick.image = UIImage(named: "radio_icon")
        cell.lblPrice.text = rupeeSymbol + " \(contestInfo.entryFeesSuggest[indexPath.row])";
        
        
        if contestInfo.moreEntryFee > 0{
            cell.vwLine.isHidden = false;
//            let discount = 100 - Double(contestInfo.moreEntryFee)!
//            let superPrice = (contestInfo.entryFeesSuggest[indexPath.row] * 100)/discount;
            cell.lblDiscountPrice.text = rupeeSymbol +  " " + contestInfo.actualEntryFees.clean;
        }else{
            cell.lblDiscountPrice.text = "";
            cell.vwLine.isHidden = true;
        }
        
        
        if indexPath.row == selectedIndex{
            cell.imgTick.image = UIImage(named: "radio_icon_active")
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row;
        collectionView.reloadData();
        txtPrice.text = rupeeSymbol +  "\(contestInfo.entryFeesSuggest[indexPath.row])";
        self.calCulateEntryFee();
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collSuggestionPrice.frame.size.width - 20)/3, height: 40);
    }
    
    
    
    
}


class SuggestionPriceCell: UICollectionViewCell {
    
    @IBOutlet weak var vwLine: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    @IBOutlet weak var imgTick: UIImageView!
}
