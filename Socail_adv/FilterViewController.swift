//
//  FilterViewController.swift
//  Socail_adv
//
//  Created by Hussam Abdellatif on 1/28/18.
//  Copyright © 2018 Hussam Abdellatif. All rights reserved.
import UIKit
import GoogleMaps
import GooglePlaces

struct MyPlace {
    var lat: Double
    var long: Double
}

class FilterViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate {
    @IBAction func Apply_Button(_ sender: Any) {
    performSegue(withIdentifier: "BackToFilterOptions", sender: self)
    
    }
    var Lat_Holder:Double?
    var Long_Holder:Double?
    var Social_Media:String?
    var followers:Int?
    var Views:Int?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToFilterOptions"{
        let destination = segue.destination as! FilterOption
        destination.Lat = chosenPlace?.lat as? Double
        destination.long = chosenPlace?.lat as? Double
        destination.Social_Media = Social_Media
        destination.Followers = followers
        destination.Views = Views
          
        }
    }
    var chosenPlace: MyPlace?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        txtFieldSearch.delegate=self
        //performSegue(withIdentifier: "BackToFilterOptions", sender: self)
        
    }
    
    //MARK: textfield
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    }
    
    // MARK: GOOGLE AUTO COMPLETE DELEGATE
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        txtFieldSearch.text=place.coordinate as? String
        chosenPlace = MyPlace(lat: place.coordinate.latitude, long: place.coordinate.longitude)
        Lat_Holder = chosenPlace?.lat
        Long_Holder = chosenPlace?.long
        self.dismiss(animated: true, completion: nil) // dismiss after place selected
       
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
  
    
    // MARK: CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
 
    
    func setupTextField(textField: UITextField, img: UIImage){
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
    }
    
    func setupViews() {
        self.view.addSubview(txtFieldSearch)
        txtFieldSearch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive=true
        txtFieldSearch.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive=true
        txtFieldSearch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive=true
        txtFieldSearch.heightAnchor.constraint(equalToConstant: 35).isActive=true
        setupTextField(textField: txtFieldSearch,img: #imageLiteral(resourceName: "facebook"))
    }
 
    //textfield input
    let txtFieldSearch: UITextField = {
        let tf=UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.placeholder="Search for a location"
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()
   
   
}


