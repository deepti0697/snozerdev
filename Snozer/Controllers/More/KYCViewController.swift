//
//  KYCViewController.swift
//  Cricshot
//
//  Created by Cricshot on 04/04/19.
//  Copyright © 2019 SVAP Infotech. All rights reserved.
//

import UIKit
import SVProgressHUD

class KYCViewController: ViewController, UIGestureRecognizerDelegate {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var viewSlider : UIView!
    
    let arrModules = ["EMAIL & MOBILE", "PAN", "BANK"] // Segment names
    var selectedModuleIndex = 0 // Index of selected segment in horizontal collection view.
    var activeControllers = [UIViewController]()
    var objAccInfo: UserData?
    var headerView: NavHeaderView?
    
    var comeFromProfile = false
    
    private lazy var kycEmail: KYCEmailMobileViewController = {
        
        // Instantiate View Controller
        var viewController = storyboard!.instantiateViewController(withIdentifier: String(describing: KYCEmailMobileViewController.self)) as! KYCEmailMobileViewController
        viewController.comeFromProfile1 = comeFromProfile
        viewController.objAccInfo = self.objAccInfo
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var kycPan: KYCPanBankViewController = {
        
        // Instantiate View Controller
        var viewController = storyboard!.instantiateViewController(withIdentifier: String(describing: KYCPanBankViewController.self)) as! KYCPanBankViewController
        viewController.isPanCard = true
        viewController.objAccInfo = self.objAccInfo
        // Add View Controller as Child View Controller
        viewController.refreshAccInfo = { [weak self](refresh) in
            if refresh {
                self?.callApiForProfile()
            }
        }
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var kycBank: KYCPanBankViewController = {
        
        // Instantiate View Controller
        var viewController = storyboard!.instantiateViewController(withIdentifier: String(describing: KYCPanBankViewController.self)) as! KYCPanBankViewController
        viewController.isPanCard = false
        viewController.objAccInfo = self.objAccInfo
        // Add View Controller as Child View Controller
        viewController.refreshAccInfo = { [weak self](refresh) in
            if refresh {
                self?.callApiForProfile()
            }
        }
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setUp();
        self.setHeaderView();
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem  = UIBarButtonItem(image: UIImage(named: "leftArrow1"), style: .plain, target: self, action: #selector(btnBackTap(_ :)))
        addAndRemoveViewController(kycEmail) // Adding wallet controller to self's child view controller.
        view.bringSubviewToFront(collectionview)
//        GetAccInfo()
        // Back swipe gesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func  setUp() {
        self.view.backgroundColor = .white;
        self.viewSlider.backgroundColor = APPCOLOR.redCustom;
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "VERIFY YOUR ACCCOUNT");
	headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    // Back swipe gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    // MARK: - Action Methods
    
    @objc func btnBackTap(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - API Methods
    
    func callApiForProfile() {
        let api = APPURL.BaseURL + APPURL.CricketUrl + APPURL.GetProfile;
        UserService.getProfileInfo(api) { (flag, response, msg) in
            if flag{
                if let info = response{
                    self.objAccInfo = info;
                    NotificationCenter.default.post(name: Notification.Name("updateAccountInfo"), object: nil, userInfo: ["AccountInfo": self.objAccInfo!])
                    appdelegate.objAccountInfo = self.objAccInfo
                }
            }
        }
    }
}


extension KYCViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - collection view datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrModules.count // No of modules
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let SportsTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportsTypeCell", for:indexPath) as! SportsTypeCell
        
        SportsTypeCell.lblSportsName.font = UIFont(name: font_medium, size: 11);
        if selectedModuleIndex == indexPath.item {
            SportsTypeCell.lblSportsName?.textColor = APPCOLOR.redCustom
            UIView.transition(with: collectionView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.viewSlider.frame = CGRect.init(x: SportsTypeCell.frame.origin.x, y: self.viewSlider.frame.origin.y, width: SportsTypeCell.frame.size.width, height: 3)
            })
        }
        else {
            SportsTypeCell.lblSportsName?.textColor = APPCOLOR.TextGrayColor;
        }
        SportsTypeCell.lblSportsName?.text = arrModules[indexPath.item]
        return SportsTypeCell
    }
    
    // Size for item in collectionview.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let arrtype = NSMutableArray()
//        for sports in arrModules {
//            arrtype.add(sports)
//        }
//        let sportsName: NSString = self.arrModules[indexPath.item] as NSString
//
//        let allsportsName = arrtype.componentsJoined(by: "") as NSString
//
//        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: 21.0)
//        let lblTextLength = (sportsName.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)], context: nil)).width
//        let totalTextLength = (allsportsName.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)], context: nil)).width
//
//        let width = 0
//        let availableWidth = (self.view.frame.size.width - CGFloat.init(width))
//        let previousWidth = (lblTextLength*100)/totalTextLength
//        let newWidth = (availableWidth*previousWidth)/100
        return CGSize(width: appdelegate.screenSize.width/3, height: 30.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == selectedModuleIndex { // If user is at same index than just returning.
            return
        }
        
        // If connected to net than navigating to different screen and selecting item in collectionview using animation and setting right bar button title accordingly.
        if Reachability.isConnectedToNetwork(){
            
            selectedModuleIndex = indexPath.item
            
            let indexPath = IndexPath(item: indexPath.item, section: 0)
            let tagCell  = collectionView.cellForItem(at: indexPath)!
            UIView.transition(with: view, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.viewSlider.frame = CGRect.init(x: tagCell.frame.origin.x, y: self.viewSlider.frame.origin.y, width: tagCell.frame.size.width, height: 3)
            })
            collectionView.reloadData()

            if indexPath.item == 0 {
                addAndRemoveViewController(kycEmail)
            }
            else if indexPath.item == 1 {
                addAndRemoveViewController(kycPan)
            }
            else {
                addAndRemoveViewController(kycBank)
            }
            
        } else { // Showing alert in case of no net connectivity.
            self.view.showToast(message: "No Internet, Please try again.")
        }
    }
    
}

// MARK: - Child ViewController Methods

// These functions are used for adding/removing child removing controllers in self. If screen is already loaded than it's only showed to user.
extension KYCViewController {
    
    func addAndRemoveViewController(_ vc: UIViewController) {
        
        if !activeControllers.contains(vc) {
            activeControllers.append(vc)
        }
        for controller in activeControllers {
            if areTheySiblings(class1: controller, class2: vc) == false {
                remove(asChildViewController: controller)
            }
        }
        add(asChildViewController: vc)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = CGRect(x: 0, y: 106, width: view.bounds.size.width, height: view.bounds.size.height - (106))
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    func areTheySiblings(class1: AnyObject!, class2: AnyObject!) -> Bool {
        
        return object_getClassName(class1) == object_getClassName(class2)
    }
    
}

// MARK: - Collection view Class

class SportsTypeCell : UICollectionViewCell
{
    @IBOutlet weak var lblSportsName: UILabel!
}
