//
//  Profile_VC.swift
//  Socail_adv
//
//  Created by Hussam Abdellatif on 1/21/18.
//  Copyright © 2018 Hussam Abdellatif. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class Profile_VC: UIViewController {
    //To do: allow user to change profile image!
    let userid = Auth.auth().currentUser?.uid  //Auth.auth().currentUser?.uid
    var which_Button:String!
    var ref: DatabaseReference! //DatabaseReference!
    var User_input_bio:String?
    @IBOutlet weak var Name_Outlet: UITextView!
    @IBOutlet weak var Save_New_Outlet: UIButton!
    @IBOutlet weak var Add_Outlet: UIButton!
    @IBOutlet weak var Profile_IMG_Outlet: UIImageView!
    @IBOutlet weak var TextLabel_Outlet: UITextView!
    @IBOutlet weak var Bio_Title: UITextView!
    @IBOutlet weak var User_Bio_Outlet: UITextView!
    @IBOutlet weak var Edit_Outlet: UIButton!
    @IBOutlet weak var Save_Button_Outlet: UIButton!
    @IBAction func Edit_Bio_Button(_ sender: Any) {
    Edit_Outlet.isHidden = true
    Add_Outlet.isHidden = true
    Save_Button_Outlet.isHidden = false
    User_Bio_Outlet.isUserInteractionEnabled = true
    }
    @IBAction func Save_Button(_ sender: Any) {
    let check_input_bio = User_Bio_Outlet.text
        if check_input_bio!.isEmpty == false && check_input_bio!.count > 10 && check_input_bio!.count < 200{
        User_input_bio = check_input_bio
        Save_Button_Outlet.isHidden = true
        Edit_Outlet.isHidden = false
        User_Bio_Outlet.isUserInteractionEnabled = false
            ref = Database.database().reference()
            ref.child("users").child(userid!).updateChildValues(["bio":User_Bio_Outlet.text])
            
        }else{
            Bio_Title.text = ("Bio: (You Bio has to be greater than 10 characters and less than 200!)")
        }
    }
    @IBAction func Add_Button(_ sender: Any) {
        Add_Outlet.isHidden = true
        Save_Button_Outlet.isHidden = true
        User_Bio_Outlet.isUserInteractionEnabled = true
        Save_New_Outlet.isHidden = false
    }
    @IBAction func Youtube_Button(_ sender: Any) {
    which_Button = "Youtube"
    }
    @IBAction func Twitter_Button(_ sender: Any) {
    which_Button = "Twitter"
    }
    @IBAction func Instagram_Button(_ sender: Any) {
    which_Button = "Instagram"
    }
    @IBAction func Facebook_Button(_ sender: Any) {
    which_Button = "Facebook"
    }
    @IBAction func Report_Button(_ sender: Any) {
    which_Button = "Youtube"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Manage_Ad"{
            let desvc = segue.destination as! Manage_Ad_VC
            desvc.user_id = userid
            desvc.S_Media_R = which_Button
            
        }
    }
    
    @IBAction func Save_New_Action(_ sender: Any) {
        let check_input_bio = User_Bio_Outlet.text
        if check_input_bio!.isEmpty == false && check_input_bio!.count > 10 && check_input_bio!.count < 200{
            User_input_bio = check_input_bio
            Save_New_Outlet.isHidden = true
            Edit_Outlet.isHidden = false
            User_Bio_Outlet.isUserInteractionEnabled = false
            ref = Database.database().reference()
            ref.child("users").child(userid!).setValue(["bio": User_Bio_Outlet.text as! String])
        }else{
            Bio_Title.text = ("Bio: (You Bio has to be greater than 10 characters and less than 200!)")
        }
    }
    override func viewDidLoad() {
        Save_New_Outlet.isHidden = true
        Save_Button_Outlet.isHidden = true
        Edit_Outlet.isHidden = true
        Add_Outlet.isHidden = true
        Name_Outlet.isUserInteractionEnabled = false
        TextLabel_Outlet.isUserInteractionEnabled = false
        Bio_Title.isUserInteractionEnabled = false
        User_Bio_Outlet.isUserInteractionEnabled = false
        
        ref = Database.database().reference()//Database.database().reference()
        ref.child("users").child(userid!).observeSingleEvent(of: .value,with: { (snapshot) in
            let userinfo = snapshot.value as! [String:AnyObject]
            let name = ("\(userinfo["firstname"] as! String) \(userinfo["lastname"] as! String) ")
            if let bio = userinfo["bio"] as? String{
                self.User_Bio_Outlet.text = bio
                self.Edit_Outlet.isHidden = false
            }else{
                self.Add_Outlet.isHidden = false
                self.User_Bio_Outlet.text = ""
            }
            self.Name_Outlet.text = name
            
            // let username = value?["username"] as? String ?? ""
            //let user = User(username: username)
        }) {(error) in
            print(error.localizedDescription)
            
            }
        //let ref = Database.
        super.viewDidLoad()

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
