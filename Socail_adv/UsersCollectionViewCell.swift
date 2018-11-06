//
//  UsersCollectionViewCell.swift
//  Socail_adv
//
//  Created by Hussam Abdellatif on 1/15/18.
//  Copyright © 2018 Hussam Abdellatif. All rights reserved.
//

import UIKit

protocol ViewAccountDelegate {
    func viewAccountAction(user_id:[String:String])
}
protocol MakeOfferDelegate {
    func sendOfferAction(user_id:[String:String])
}


class UsersCollectionViewCell: UICollectionViewCell{
    var delegate:ViewAccountDelegate?
    var delegate2:MakeOfferDelegate?
    var uid:[String:String]!

    @IBOutlet weak var User_Name: UITextField!
    @IBOutlet weak var Profile_Pic: UIImageView!
    @IBOutlet weak var Social_Media: UITextField!
    @IBOutlet weak var Followers: UITextField!
    @IBOutlet weak var Views: UITextField!
    @IBOutlet weak var Country: UITextField!
    @IBOutlet weak var State: UITextField!
    @IBOutlet weak var L1: UITextView!
    @IBOutlet weak var L2: UITextView!
    @IBOutlet weak var L3: UITextView!
    @IBOutlet weak var L4: UITextView!
    @IBOutlet weak var L5: UITextView!
   
    
    @IBAction func ViewTheAccount_Button(_ sender: Any) {
        delegate?.viewAccountAction(user_id: uid)
    }
    @IBOutlet weak var Make_An_Offer_Button: UIButton!
    
    
    @IBAction func Make_An_Offer_Action(_ sender: Any) {
        delegate2?.sendOfferAction(user_id: uid)
    }
    
    
    /*
    var post: Post?{
        didSet{
            self.updateUI()
        }
    }
    private func updateUI(){
        if let post = post {
            
         //   User_Name.text = post.First_Name
        }else{
            User_Name.text = nil
        }
    }
    */
    override func layoutSubviews() {
        User_Name.isUserInteractionEnabled = false
        Profile_Pic.isUserInteractionEnabled = false
        Social_Media.isUserInteractionEnabled = false
        Followers.isUserInteractionEnabled = false
        Views.isUserInteractionEnabled = false
        Country.isUserInteractionEnabled = false
        State.isUserInteractionEnabled = false
        L1.isUserInteractionEnabled = false
        L2.isUserInteractionEnabled = false
        L3.isUserInteractionEnabled = false
        L4.isUserInteractionEnabled = false
        L5.isUserInteractionEnabled = false
        super.layoutSubviews()
        self.layer.cornerRadius = 4.5
        layer.shadowRadius = 3.75
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 5, height: 10)
        self.clipsToBounds=false

    }
}
