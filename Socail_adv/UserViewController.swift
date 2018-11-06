//
//  UserCollectionViewController.swift
//  Socail_adv
//
//  Created by Hussam Abdellatif on 1/15/18.
//  Copyright © 2018 Hussam Abdellatif. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class UserViewController: UIViewController,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView:  UICollectionView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewTheAccount"{
           let desvc = segue.destination as! ViewTheAccount
            //print("hellllllllo\(sender as? String)")
            desvc.user_id = sender as? [String:String]
         }
        if segue.identifier == "Make_anOffer1"{
            let desvc = segue.destination as! Make_AnOffer
            desvc.user_id = sender as? [String:String]
        }
    }
    
    @IBAction func Filter_Button(_ sender: Any) {
      
    }
    
    
    let cellScaling: CGFloat = 0.6
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth)/2
        let insetY = (view.bounds.height - cellHeight)/2
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        collectionView?.dataSource = self
        fetchPosts()
    }
    func fetchPosts(){
        let ref = Database.database().reference()//Database.database().reference()
        ref.child("posts").queryOrderedByKey().queryLimited(toFirst: 10).observeSingleEvent(of: .value) { (snap) in
            if snap.exists() == true{
            let postsSnap = snap.value as! [String:AnyObject]
            for(x,post) in postsSnap{
               
                let posst = Post()
                if let Country = post["Country"] as? String, let Followers = post["Followers"] as? Int,let S_Media = post["Social_Media"] as? String, let State = post["State"] as? String, let Viewers = post["Views"] as? Int, let firstName = post["firstname"] as? String, let lastname = post["lastname"] as? String, let profilepic = post["urlimg"] as? String, let uid = post["u_id"] as? String, let postid = x as? String{
                    posst.Country = Country
                    posst.firstname = firstName
                    posst.lastname = lastname
                    posst.Followers = Followers
                    posst.Viewers = Viewers
                    posst.uid = uid
                    posst.profilepic = profilepic
                    posst.S_Media = S_Media
                    posst.State = State
                    posst.Post_id = postid
                    self.posts.append(posst)
                    
                }
                self.collectionView.reloadData()
            }
            }
        }
        ref.removeAllObservers()
    }
   

func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return self.posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! UsersCollectionViewCell
        //cell.post = posts[indexPath.item]
        cell.User_Name.text = "\(self.posts[indexPath.item].firstname!) \(self.posts[indexPath.item].lastname!)"
        cell.Country.text = self.posts[indexPath.item].Country
        cell.Social_Media.text = self.posts[indexPath.item].S_Media
        cell.Followers.text = "\(self.posts[indexPath.item].Followers!) "
        cell.Views.text = "\(self.posts[indexPath.item].Viewers!)"
        cell.State.text = self.posts[indexPath.item].State
        cell.uid = ["userid":self.posts[indexPath.item].uid , "postid":self.posts[indexPath.item].Post_id]
        
        cell.delegate = self
        //cell.View_Account_Outlet.addTarget(self, action: #selector(buttonTappedInCollectionViewCell), for: .touchUpInside)
        let url = URLRequest(url: URL(string: self.posts[indexPath.item].profilepic)!)
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                cell.Profile_Pic.image = UIImage(data: data!)
            }
            
        }
        task.resume()
    
        
        
        return cell
    }
    
    
    @IBAction func signout(_ sender: Any) {
        print(Auth.auth().currentUser) //Auth.auth().currentUser)
        do{
            try Auth.auth().signOut()//Auth.auth().signOut()
        }catch let logouterror{
            print(logouterror)
        }
        print(Auth.auth().currentUser)//Auth.auth().currentUser)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"HomeId")
        self.present(vc, animated: true, completion: nil)
    }
   
}

extension UserViewController: ViewAccountDelegate{
    
    func viewAccountAction(user_id: [String:String]) {
     performSegue(withIdentifier: "ViewTheAccount", sender: user_id)
    }
    func sendOfferAction(user_id: [String:String]){
     performSegue(withIdentifier: "Make_anOffer1", sender: user_id)
    }
    
}
