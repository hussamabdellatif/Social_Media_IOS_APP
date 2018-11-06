//
//  Sign_Up_Con.swift
//  Socail_adv
//
//  Created by Hussam Abdellatif on 1/9/18.
//  Copyright © 2018 Hussam Abdellatif. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class Sign_Up_Con: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Photo_Button: UIButton!
    @IBOutlet weak var First_Name: UITextField!
    @IBOutlet weak var Last_Name: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Confirm_Password: UITextField!
    @IBOutlet weak var Error_Label: UILabel!
    
    let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9].*[0-9])(?=.*[a-z]).{8,}$"
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    var Email_From_Page1 = String()
    var selected_image:UIImage?
    var ref: DatabaseReference!
    var userStorage: StorageReference!
    
    func Validate_Input(Email:String?, First_Name:String?, Last_Name:String?, Password:String?, Confirm_Password:String?) -> Bool {
        //Check that all parameters are not empty
        
        
        
        if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: Email){
            Error_Label.text = "Email Field is incorrect"
            return false
        }
        if  !NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: Password) {
            Error_Label.text = "Password = 9 chars, 1 upper &  1 lower case"
            return false
        }
        if Password != Confirm_Password{
            Error_Label.text = "Passwords do not match"
            return false
        }
        
        Error_Label.text = "Everything working fine"
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference() //Database.database().reference()
        Email.text = Email_From_Page1
        // Do any additional setup after loading the view.
        let storage = Storage.storage().reference(forURL: "gs://socialadv-84f10.appspot.com")//Storage.storage().reference(forURL: "gs://socialadv-84f10.appspot.com")
        userStorage = storage.child("users_profile_picture")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Profile_Photo(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = true
        self.present(image, animated: true)
        {
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let edit_image = info[UIImagePickerControllerEditedImage] as? UIImage{
            selected_image = edit_image
            
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
           selected_image = image
         
        }else{
            //Error
        }
        Photo_Button.setBackgroundImage(selected_image, for: .normal)
        Photo_Button.setTitle("", for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Sign_Up_Button(_ sender: Any) {
       let First_Name_Value = First_Name.text
       let Email_Value = Email.text
       let Last_Name_Value = Last_Name.text
       let Password_Value = Password.text
       let Password_Value_Confirm = Confirm_Password.text
       let check_input = Validate_Input(Email: Email_Value, First_Name: First_Name_Value, Last_Name: Last_Name_Value, Password: Password_Value, Confirm_Password: Password_Value_Confirm)
        
        if  ((First_Name_Value?.isEmpty)! || (Email_Value?.isEmpty)! || (Last_Name_Value?.isEmpty)! || (Password_Value?.isEmpty)! || (Password_Value_Confirm?.isEmpty)!){
            Error_Label.text = "Please Fill All Fields"
            return
        }
        if check_input {
           
        
        //create an Authentication account
        //Auth.auth().createUser(withEmail: Email_Value!, password: Password_Value!) { (user, error) in
            // [START_EXCLUDE]
            Auth.auth().createUser(withEmail: Email_Value!, password: Password_Value!) {(user,error) in
            if let error = error {
                self.Error_Label.text = error.localizedDescription
                print(error.localizedDescription)
                return
            }
            if let user = user{
                print("\(user.email!) created")
                let imageRef = self.userStorage.child("\(user.uid).jpg")
                let data = UIImageJPEGRepresentation(self.selected_image!, 0.5)
                let upload_task = imageRef.putData(data!, metadata: nil, completion: { (meta, err) in
                    if err != nil{
                        self.Error_Label.text = err!.localizedDescription
                        print(err!.localizedDescription)
                    }else{
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil{
                                self.Error_Label.text = er?.localizedDescription
                                print(err!.localizedDescription)
                            }
                            if let url = url{
                                //add user info to the database
                                let userInfo: [String: Any] = ["uid" : user.uid, "firstname": First_Name_Value, "lastname": Last_Name_Value, "urlToImg": url.absoluteString]
                                self.ref.child("users").child((user.uid)).setValue(userInfo)
                            }
                        })
                    }
                    
                })
            }
            
            
        
           
            
            // [END_EXCLUDE]
        }
    

        
        }
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
