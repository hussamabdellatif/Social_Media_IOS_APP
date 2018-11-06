//
//  FilterOption.swift
//  Socail_adv
//
//  Created by Hussam Abdellatif on 2/4/18.
//  Copyright © 2018 Hussam Abdellatif. All rights reserved.
//

import UIKit

class FilterOption: UIViewController {
    var Social_Media:String?
    var Lat:Double?
    var long:Double?
    var Followers:Int?
    var Views:Int?
    //picker View Variables
    var picker_view_data:[String?] = []
    var picker_view_selected_row:String?
    var ROW:Any?
    
    
    var Filter_type:String?
    
    
    //Button Outlets
    @IBOutlet weak var SM_Outlet: UIButton!
    @IBOutlet weak var Followers_Outlet: UIButton!
    @IBOutlet weak var Views_Outlet: UIButton!
    @IBOutlet weak var Country_Outlet: UIButton!
    @IBOutlet weak var Filter_Options_Outlet: UITextView!
    @IBOutlet weak var Apply_Actions_Outlet: UIButton! //main apply actions outlet
    @IBOutlet weak var Cancel_Outlet: UIButton! //main cancel outlet
    @IBOutlet weak var Go_back_Outlet: UIButton!
    @IBOutlet weak var Save_Changes_Outlet: UIButton!
    
    @IBOutlet weak var Picker_View: UIPickerView!
    
    //Button Actions
    @IBAction func SM_Action(_ sender: Any) {
     hideEverything()
     show_For_Filter()
     Filter_Options_Outlet.text = "Filter based on Social Media"
     Picker_View.delegate = self
     picker_view_data = ["Any", "Instagram", "Twitter", "Facebook", "Youtube"]
     Filter_type = "Social_Media"
    }
    @IBAction func Followers_Action(_ sender: Any) {
        hideEverything()
        show_For_Filter()
        Filter_Options_Outlet.text = "Filter based on Followers"
        Picker_View.delegate = self
        picker_view_data = ["Any", "0 to 500", "500-1k", "1k-5k", "5k-10k", "10k-50k", "50k-100k", "100k-500k", "500k-1M", "1M-2M", "2M-5M", "5M-10M", ">10M" ]
         Filter_type = "Followers"
    }
    @IBAction func Views_Action(_ sender: Any) {
        hideEverything()
        show_For_Filter()
        Filter_Options_Outlet.text = "Filter based on Views"
        picker_view_data = ["Any", "0 to 500", "500-1k", "1k-5k", "5k-10k", "10k-50k", "50k-100k", "100k-500k", "500k-1M", "1M-2M", "2M-5M", "5M-10M", ">10M" ]
         Filter_type = "Views"
    }
    @IBAction func Country_Action(_ sender: Any) {
        
    }
    //main apply chnages button
    @IBAction func Apply_Changes_Action(_ sender: Any) {
        // wrap with if statement to check if they are nil!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        print("Social Media: \(Social_Media!)")
        print("Followers: \(Followers!)")
        print("Views: \(Views!)")
        print("Lat: \(Lat!)")
        print("Lat: \(long!)")
        
    }
    //main cancel button
    @IBAction func Cancel_Button(_ sender: Any) {
    }
    @IBAction func Go_Back_Action(_ sender: Any) {
    }
    @IBAction func Save_Changes_Action(_ sender: Any) {
        Picker_View.isHidden = true
        Go_back_Outlet.isHidden = true
        Save_Changes_Outlet.isHidden = true
        show_Everything()
        if Filter_type != nil{
        switch Filter_type! {
        case "Social_Media":
            Social_Media = picker_view_selected_row
        case "Followers":
        Followers = ROW as? Int
        case "Views":
        Views = ROW as? Int
        default:
        print("Error in Filter OPTION line 91")
        }
        }
    }
    
    
   
    func hideEverything(){
        SM_Outlet.isHidden = true
        Followers_Outlet.isHidden = true
        Views_Outlet.isHidden = true
        Country_Outlet.isHidden = true
        Apply_Actions_Outlet.isHidden = true
        Cancel_Outlet.isHidden = true
    }
    func show_For_Filter(){
    Picker_View.isHidden = false
    Go_back_Outlet.isHidden = false
    Save_Changes_Outlet.isHidden = false
    }
    
    func show_Everything(){
        SM_Outlet.isHidden = false
        Followers_Outlet.isHidden = false
        Views_Outlet.isHidden = false
        Country_Outlet.isHidden = false
        Apply_Actions_Outlet.isHidden = false
        Cancel_Outlet.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Picker_View.isHidden = true
        Go_back_Outlet.isHidden = true
        Save_Changes_Outlet.isHidden = true
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GMAPS_ID"{
            let dest = segue.destination as! FilterViewController
            if Social_Media != nil{
                dest.Social_Media = Social_Media
            }
            if Followers != nil{
                dest.followers = Followers
            }
            if Views != nil{
                dest.Views = Views
            }
        }
    }
    
    
    
}

extension FilterOption: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker_view_data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker_view_data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        picker_view_selected_row = picker_view_data[row]
        ROW = row
    }
    
}
