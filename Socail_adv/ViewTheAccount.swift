//
//  ViewTheAccount.swift
//  Socail_adv
//
//  Created by Hussam Abdellatif on 1/17/18.
//  Copyright © 2018 Hussam Abdellatif. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ViewTheAccount: UIViewController {
    //user_id contains the user id use it to search database and return his info
    var user_id:[String:String]?
    
    
    var post_id:String?
    var url:String?
    @IBOutlet weak var Name: UITextView!
    @IBOutlet weak var Image: UIImageView!
    @IBAction func Link_SMedia(_ sender: Any) {
       print("hehehe")
        if let url = URL(string: "\(url as! String)") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    @IBOutlet weak var Bio: UITextView!
    @IBAction func Make_An_Offer(_ sender: Any) {
    }
    
    var Imageurl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var USER_ID = user_id!["userid"] as? String
        var POST_ID = user_id!["postid"] as? String
        let ref = Database.database().reference()//Database.database().reference()
        ref.child("posts").child(POST_ID!).observeSingleEvent(of: .value) {(snap) in
            let user_info = snap.value as! [String:AnyObject]
            self.Name.text = ("\(user_info["firstname"] as! String) \(user_info["lastname"] as! String)")
            self.Imageurl = user_info["urlimg"] as! String
            
            
            self.url = user_info["URL"] as? String
            let urlimg = URLRequest(url: URL(string: (user_info["urlimg"] as! String))!)
            let task = URLSession.shared.dataTask(with: urlimg) {
                (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.Image.image = UIImage(data: data!)
                }
                
            }
            task.resume()
         }
        
            ref.removeAllObservers()
        ref.child("users").child(USER_ID!).observeSingleEvent(of: .value) { (snapshot) in
            let response = snapshot.value as! [String: AnyObject]
            if let bio = response["bio"]{
                self.Bio.text = " " //bio as! String
            }else{
                self.Bio.text = " "
            }
        }
        ref.removeAllObservers()
        
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
