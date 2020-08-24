//
//  ReactionListVC.swift
//  Snozer
//
//  Created by Admin on 20/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class ReactionListVC: ViewController {
    
    var arrReactions : [CommonDto] = [];
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var collReact: UICollectionView!
    var selectReactionId: ((_ reactionId: String) -> Void)?
    
    @IBOutlet weak var layoutCollectionWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        collReact.delegate = self;
        collReact.dataSource = self;
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.collReact.reloadData();
        }
    }

    
    @IBAction func actionForCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
}

extension ReactionListVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrReactions.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReactionCell", for: indexPath) as! ReactionCell
        cell.imgReact.sd_setImage(with:  URL.init(string: arrReactions[indexPath.row].image),placeholderImage: UIImage.init(named: "user_icon"))
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60);
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectReactionId!(arrReactions[indexPath.row].id);
        self.dismiss(animated: true, completion: nil);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 0.0
    }
    
}

class ReactionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgReact: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwLine: UIView!
}
