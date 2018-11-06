//
//  Make_AnOffer.swift
//  Socail_adv
//
//  Created by Hussam Abdellatif on 2/9/18.
//  Copyright © 2018 Hussam Abdellatif. All rights reserved.
//

import UIKit
import Firebase

class Make_AnOffer: UIViewController {
    let logged_in_userid = Auth.auth().currentUser?.uid
    //user id recieved from timeline posts
    var user_id:[String:String]?
    override func viewDidLoad() {
        print("logged in user id::: \(logged_in_userid)")
        print("user account:::: \(user_id?["userid"] as? String)")
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

 

}
