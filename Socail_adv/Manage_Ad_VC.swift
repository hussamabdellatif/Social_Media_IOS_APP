//
//  Manage_Ad_VC.swift
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
import FBSDKLoginKit
import TwitterKit
import GoogleAPIClientForREST
import GoogleSignIn


class Manage_Ad_VC: UIViewController, FBSDKLoginButtonDelegate, GIDSignInDelegate, GIDSignInUIDelegate, UIWebViewDelegate {
    //API Returns
    var Facebook_URL:String?
    var Twitter_URL:String?
    var Instagram_URl:String?
    var Youtube_URL:String?
    var Instagram_check = false
    //Youtube API Begins HERE >>>
    
    private let scopes = [kGTLRAuthScopeYouTubeReadonly]
    private let service = GTLRYouTubeService()
    let signInButton = GIDSignInButton()
    
    //Sign in to google account Stage one of youtube API
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            fetchChannelResource()
        }
    }
    //sets up the query for youtube API..The quiery will return statistics and id
    func fetchChannelResource() {
        let query = GTLRYouTubeQuery_ChannelsList.query(withPart: "snippet,statistics,id")
        //query.identifier = "UC_x5XG1OV2P6uZZ5FSM9Ttw"
        // To retrieve data for the current user's channel, comment out the previous
        // line (query.identifier ...) and uncomment the next line (query.mine ...)
         query.mine = true
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    //handles the response of the api, and checks for errors.Finally saves the youtube url
    @objc func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_ChannelListResponse,
        error : NSError?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
       
        if let channels = response.items, !channels.isEmpty {
            let channel = response.items![0]
            _ = channel.snippet!.title
            let channel_id = channel.identifier
            _ = channel.statistics?.viewCount
            if channel_id != nil{
                Youtube_URL = "https://www.youtube.com/channel/\(channel_id as! String)"
            }else{
                print("Instagram.channel id was nil")
            }
            
        }
      
    }
    //shows an alert if something goes wrong..make it more userfriend;y pre-release
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    //Youtube API Call Ends Here...
    
    
    //Facebook API Instructions
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        if error != nil{
            print("?>>>>>>>")
            print(">>>>>>>.....\n\(error)")
            print("?>>>>>>>")
        }else{
            //if no error occured upon logging in this block fetchs facebook id
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"link"]).start(completionHandler: { (connection, result, error2) in
                if error2 != nil{
                    print("failed to start graph with error:")
                    print(error2!)
                    return
                }
                var fields = result as? [String:Any]
           
                //var id currently holds the facebook id which u can add to a url to access facebook page.
                let id = fields!["link"] as? String
                if id != nil{
                let url = id as! String
                self.Facebook_URL = url
                self.Feedback_Outlet.text = "Facebook Linked Successfully with channel id: \(url)..."
                self.Feedback_Outlet.isHidden = false
               
                }
                })
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    //^^^ end of Facebook API Call, the link is save to Facebook_URL
    
    //Instagrams API Begins Here:
    func unSignedRequest () {
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [API.INSTAGRAM_AUTHURL,API.INSTAGRAM_CLIENT_ID,API.INSTAGRAM_REDIRECT_URI, API.INSTAGRAM_SCOPE ])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        WebView.loadRequest(urlRequest)
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        Indicator.isHidden = false
       Indicator.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Indicator.isHidden = true
        Indicator.stopAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(API.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            self.WebView.isHidden = true
            self.Indicator.isHidden = true
            self.Feedback_Outlet.isHidden = false
            self.Feedback_Outlet.text = "Successfully loged Instagram"
            return false;
        }
        return true
    }
    
    func handleAuth(authToken: String)  {
        let authURL = "https://api.instagram.com/v1/users/self/?access_token=\(authToken)"
        let url = URL(string: authURL)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let response = json as! NSDictionary
                let username = response.object(forKey: "data") as! NSDictionary
                let username3 = username.object(forKey: "username")
                if username3 != nil{
                    self.Instagram_URl = "https://www.instagram.com/\(username3 as! String)/"
                }else{
                    self.Feedback_Outlet.isHidden = false
                    self.Feedback_Outlet.text = "Couldnt link Instagram"
                    
                }
                
            } catch let error as NSError {
                print(error)
            }
        }).resume()
        
    }
    //Instagram API CALL Ends Here^^^
    
    
    
    
    
    func check_allinputs()->Bool{
        if S_Media_Outlet.text != "" && Followers_Outlet.text != "" && Views_Outlet.text != "" && Country_Outlet.text != "" && State_Outlet.text != "" && Int(Followers_Outlet.text!) != nil && Int(Views_Outlet.text!) != nil{
            return true
        }
        return false
    }
    
    var insta_username: String?
    var ref: DatabaseReference!
    var S_Media_R:String!
    var user_id:String!
    
    @IBOutlet weak var back_outlet: UIButton!
    @IBAction func back_button(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var Indicator: UIActivityIndicatorView!
    @IBOutlet weak var WebView: UIWebView!
    @IBOutlet weak var Feedback_Outlet: UITextView!
    @IBOutlet weak var Title_Outlet: UITextView!
    @IBOutlet weak var Warning_Outlet: UITextView!
    @IBOutlet weak var L1: UITextView!
    @IBOutlet weak var L2: UITextView!
    @IBOutlet weak var L3: UITextView!
    @IBOutlet weak var L4: UITextView!
    @IBOutlet weak var L5: UITextView!
    @IBOutlet weak var S_Media_Outlet: UITextField!
    @IBOutlet weak var Followers_Outlet: UITextField!
    @IBOutlet weak var Views_Outlet: UITextField!
    @IBOutlet weak var Country_Outlet: UITextField!
    @IBOutlet weak var State_Outlet: UITextField!
    @IBOutlet weak var Edit_Outlet: UIButton!
    @IBAction func Edit_Button(_ sender: Any) {
    }
    @IBOutlet weak var Link_Button: UIButton!
    //LINK BUTTON--Intiates the API Call to whichever Social Media Account the user wants.
    @IBAction func Link_Button_Action(_ sender: Any) {
        if S_Media_R == "Facebook"{
            //if media == facebook then activate the two functions above that deal with the facebook delegate
            if check_allinputs() == true{
                
                let button = FBSDKLoginButton()
                button.sendActions(for: .touchUpInside)
                button.delegate = self
                
            }else{
                Feedback_Outlet.isHidden = false
            }
        }else if S_Media_R == "Twitter"{
            if check_allinputs() == true{
            let logInButton = TWTRLogInButton(logInCompletion: { session, error in
                if (session != nil) {
                    if session?.userName != nil{
                    var url = "https://twitter.com/\(session?.userName as! String)"
                    self.Twitter_URL = url
                    self.Feedback_Outlet.text = "Youtube Linked Successfully with channel id: \(url)..."
                    self.Feedback_Outlet.isHidden = false
                    }else{
                        print("twitter.session.username is nil")
                    }
                } else {
                    print("error: \(error?.localizedDescription)");
                }
            })
            //if this works without adding the button to the subview then perfect if not un comment the two lines under this...
            //logInButton.center = self.view.center
            //self.view.addSubview(logInButton)
            logInButton.sendActions(for: .touchUpInside)
            }else{
                Feedback_Outlet.isHidden = false
            }
        }else if S_Media_R == "Instagram"{
            WebView.delegate = self
            WebView.isHidden = false
            Indicator.isHidden = false
            unSignedRequest()
            //performSegue(withIdentifier: "insta_ID12", sender: self)
            // Do any additional setup after loading the view.
            
        }else if S_Media_R == "Youtube"{
            if check_allinputs() == true{
            signInButton.sendActions(for: .touchUpInside)
            Feedback_Outlet.text = "Youtube Linked Successfully with channel id: \(Youtube_URL)..."
            Feedback_Outlet.isHidden = false
            }else{
                Feedback_Outlet.isHidden = false
            }
        }else{
            //S_Media_R is either empty or writter in a different manner
            print(">>>>>>>>\n")
            print("Error from checking S_Media_R check the if conditions!")
            print("This is S_Media_R check me:  \(S_Media_R)")
            print(".....")
        }
    }
    @IBOutlet weak var Add_Outlet: UIButton!
    @IBAction func Add_Button(_ sender: Any) {
     Edit_Outlet.isHidden = true
     Save_Outlet.isHidden = false
     S_Media_Outlet.text = S_Media_R
     showEverything()
     enableInteraction()
        //Due to how the Instagram API is set up, I need the user to link first then fill in the fields!
        if S_Media_R == "Instagram"{
             Link_Button_Action(self)
            //Link_Button.sendActions(for: .touchUpInside)
        }
     }
    @IBOutlet weak var Save_Outlet: UIButton!
    @IBAction func Save_Button(_ sender: Any) {
        let country_text = Country_Outlet.text
        let state_text = State_Outlet.text
        //configure each api
        if S_Media_R == "Facebook"{
            if check_allinputs() == true && Facebook_URL != nil{
                let follower_text = Int(Followers_Outlet.text!)
                let views_text = Int(Views_Outlet.text!)
                sendToDatabase(Social_Media:S_Media_R as! String, Followers: follower_text!, Views:views_text!, Country:country_text as! String, State:state_text as! String, Url:Facebook_URL as! String, Update: false)
               back_outlet.sendActions(for: .touchUpInside)
            }else{
                Feedback_Outlet.isHidden = false
                Feedback_Outlet.text = "Opps! Something went wrong. Make sure all feilds are filled in & try linking again. Logout of Facebook when you click the link button and relink again."
            }
        }else if S_Media_R == "Twitter"{
            if check_allinputs() == true && Twitter_URL != nil{
                let follower_text = Int(Followers_Outlet.text!)
                let views_text = Int(Views_Outlet.text!)
                sendToDatabase(Social_Media:S_Media_R as! String, Followers: follower_text!, Views:views_text!, Country:country_text as! String, State:state_text as! String, Url:Twitter_URL as! String, Update: false)
                back_outlet.sendActions(for: .touchUpInside)
            }else{
                Feedback_Outlet.isHidden = false
                Feedback_Outlet.text = "Opps! Something went wrong. Make sure all feilds are filled in & try linking again."
            }
        }else if S_Media_R == "Instagram"{
            if check_allinputs() == true && Instagram_URl != nil{
                let follower_text = Int(Followers_Outlet.text!)
                let views_text = Int(Views_Outlet.text!)
                sendToDatabase(Social_Media:S_Media_R as! String, Followers: follower_text!, Views:views_text!, Country:country_text as! String, State:state_text as! String, Url:Instagram_URl as! String, Update: false)
                back_outlet.sendActions(for: .touchUpInside)
            }else{
                Feedback_Outlet.isHidden = false
                Feedback_Outlet.text = "Opps! Something went wrong. Make sure all feilds are filled in & try linking again."
            }
        }else if S_Media_R == "Youtube"{
            if check_allinputs() == true && Youtube_URL != nil{
                let follower_text = Int(Followers_Outlet.text!)
                let views_text = Int(Views_Outlet.text!)
                sendToDatabase(Social_Media:S_Media_R as! String, Followers: follower_text!, Views:views_text!, Country:country_text as! String, State:state_text as! String, Url: Youtube_URL as! String, Update: false)
                back_outlet.sendActions(for: .touchUpInside)
            }else{
                Feedback_Outlet.isHidden = false
                Feedback_Outlet.text = "Opps! Something went wrong. Make sure all feilds are filled in & try linking again."
            }
        }else{
            //S_Media_R is either empty or writter in a different manner
            print(">>>>>>>>\n")
            print("Error from checking S_Media_R check the if conditions!")
            print("This is S_Media_R check me:  \(S_Media_R)")
             print(".....")
        }
        
        
    }
   
    
    func sendToDatabase(Social_Media:String, Followers:Int, Views:Int, Country:String,State:String, Url:String, Update: Bool ){
        if Update == true{
            
        }else if  Update == false{
            ref = Database.database().reference()
            ref.child("users").child(user_id).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? [String:AnyObject]
                let name = value?["firstname"] as! String
                let lastname = value?["lastname"] as! String
                let imgurl = value?["urlToImg"] as! String
                let post :[String:Any] = ["Social_Media":Social_Media, "Followers":Followers as! Int, "Views":Views as! Int, "Country":Country, "State": State, "URL":Url, "u_id": self.user_id, "firstname": name as! String, "lastname": lastname as! String, "urlimg": imgurl as! String]
                self.ref.child("posts").childByAutoId().setValue(post)
            }
            //add new contents to the database":
            
        }
    }
    
    func hideEverything(){
        Indicator.isHidden = true
        WebView.isHidden = true
        Feedback_Outlet.isHidden = true
        Save_Outlet.isHidden = true
        Edit_Outlet.isHidden = true
        Warning_Outlet.isHidden = true
        L1.isHidden = true
        L2.isHidden = true
        L3.isHidden = true
        L4.isHidden = true
        L5.isHidden = true
        S_Media_Outlet.isHidden = true
        Followers_Outlet.isHidden = true
        Views_Outlet.isHidden = true
        Country_Outlet.isHidden = true
        State_Outlet.isHidden = true
        Link_Button.isHidden = true
    }
    func showEverything(){
          //Edit_Outlet.isHidden = false
          Save_Outlet.isHidden = false
          Warning_Outlet.isHidden = false
          L1.isHidden = false
          L2.isHidden = false
          L3.isHidden = false
          L4.isHidden = false
          L5.isHidden = false
          S_Media_Outlet.isHidden = false
          Followers_Outlet.isHidden = false
          Views_Outlet.isHidden = false
          Country_Outlet.isHidden = false
          State_Outlet.isHidden = false
          Link_Button.isHidden = false
          Add_Outlet.isHidden = true
    }
    
    func removeInteraction(){
        Title_Outlet.isUserInteractionEnabled = false
        Warning_Outlet.isUserInteractionEnabled = false
        L1.isUserInteractionEnabled = false
        L2.isUserInteractionEnabled = false
        L3.isUserInteractionEnabled = false
        L4.isUserInteractionEnabled = false
        L5.isUserInteractionEnabled = false
        S_Media_Outlet.isUserInteractionEnabled = false
        Followers_Outlet.isUserInteractionEnabled = false
        Views_Outlet.isUserInteractionEnabled = false
        Country_Outlet.isUserInteractionEnabled = false
        State_Outlet.isUserInteractionEnabled = false
        Link_Button.isUserInteractionEnabled = false
    }
    func enableInteraction(){
        Followers_Outlet.isUserInteractionEnabled = true
        Views_Outlet.isUserInteractionEnabled = true
        Country_Outlet.isUserInteractionEnabled = true
        State_Outlet.isUserInteractionEnabled = true
        Link_Button.isUserInteractionEnabled = true
        
    }
    
    override func viewDidLoad() {
        if Instagram_check == true{
            Feedback_Outlet.isHidden = false
            Feedback_Outlet.text = Instagram_URl
        }
        
        //////
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        // Add the sign-in button.
        view.addSubview(signInButton)
        signInButton.isHidden = true
        // Add a UITextView to display output.
        //output.isHidden = true
       // view.addSubview(output);
        //output.isHidden = true
        ///////
        hideEverything()
        removeInteraction()
        Title_Outlet.text = "Manage Your \(S_Media_R as! String) Page!"
        ref = Database.database().reference() //Database.database().reference()
        ref.child("posts").queryOrdered(byChild: "u_id").queryEqual(toValue: user_id).observeSingleEvent(of: .value, with: { (snap) in
            let user_info = snap.value as? [String:AnyObject]
            if user_info == nil{
                self.hideEverything()
            }else{
                for(_,post) in user_info!{
                    let check_Sm = post["Social_Media"] as? String
                    if check_Sm == self.S_Media_R{
                        let followers = post["Followers"] as! Int
                        let Views = post["Views"] as! Int
                        let Country = post["Country"] as! String
                        let State = post["State"] as! String
                        self.S_Media_Outlet.text = check_Sm
                        self.Followers_Outlet.text = ("\(followers)")
                        self.Views_Outlet.text = ("\(Views)")
                        self.State_Outlet.text = State
                        self.Country_Outlet.text = Country
                        self.showEverything()
                        self.Edit_Outlet.isHidden = false
                        self.Save_Outlet.isHidden = true
                        self.removeInteraction()
                        return
                    }
                }
            }
            
           // print(user_info)
        }) {(error) in
            print(error.localizedDescription)
        }
        ref.removeAllObservers()
        //observeSingleEvent(of: .value, with: { (Snap) in
            
       
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //send input to view controller 3 so the user doesnt have to refill fields again due to the way instagram's api is setup.
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}




