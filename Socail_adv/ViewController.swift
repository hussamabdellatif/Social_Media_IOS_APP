//
//  ViewController.swift
//  Socail_adv
//
//  Created by Hussam Abdellatif on 1/7/18.
//  Copyright © 2018 Hussam Abdellatif. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
   
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Passwordf: UITextField!
    @IBOutlet weak var Error_Label: UILabel!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil { //Auth.auth().currentUser != nil {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"TimeLineController_Id")
            self.present(vc, animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if Email.text != ""{
        var Sign_Up = segue.destination as! Sign_Up_Con
        Sign_Up.Email_From_Page1 = Email.text!
       // var timeline_info = segue.destination as! TimeLineController
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Sign_IN(_ sender: Any) {
        if Email.text == "" || Passwordf.text == "" {
            Error_Label.text = "fill in fields"
            
        }else{
           
        //Auth.auth().signIn(withEmail: Email.text!, password: Passwordf.text!) { (user, error) in
            //FIRAuth.auth()?.signIn(withEmail: Email.text!, password: Passwordf.text!){ (user, error) in
            Auth.auth().signIn(withEmail: Email.text!, password: Passwordf.text!, completion: { (user, error) in
                if let error = error{
                    self.Error_Label.text = error.localizedDescription
                    print(error.localizedDescription)
                    print(error)
                    return
                }
                if let user = user{
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"TimeLineController_Id")
                    self.present(vc, animated: true, completion: nil)
                }
            })
           
    
        }
    }
    
   
    
    
    @IBAction func Sign_up(_ sender: Any) {
       performSegue(withIdentifier: "Sign_Up_Seg", sender: self)
    }
    
    
   
    
    


}

