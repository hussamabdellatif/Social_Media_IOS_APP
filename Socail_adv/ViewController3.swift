//
//  ViewController3.swift
//  Socail_adv
//
//  Created by Hussam Abdellatif on 1/24/18.
//  Copyright © 2018 Hussam Abdellatif. All rights reserved.
//

import UIKit
import WebKit

//setting up a delegate to pass the response of the Instagram API back to Manage_Ad_VC


class ViewController3: UIViewController, UIWebViewDelegate {
    
    
    
    @IBOutlet weak var WebView1: UIWebView!
    
    @IBOutlet weak var cancel_Outlet: UIButton!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
     override func viewDidLoad() {
        super.viewDidLoad()
        WebView1.delegate = self
        unSignedRequest()
        
        
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
    
    //MARK: - unSignedRequest
    func unSignedRequest () {
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [API.INSTAGRAM_AUTHURL,API.INSTAGRAM_CLIENT_ID,API.INSTAGRAM_REDIRECT_URI, API.INSTAGRAM_SCOPE ])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        WebView1.loadRequest(urlRequest)
    }
  
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = false
        loginIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = true
        loginIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(API.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
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
                    var url_username = username3 as! String
                    var url = "https://www.instagram.com/\(url_username)/"
                    
                    
                    
                }else{
                     self.dismiss(animated: true, completion: nil)
                }
                
            } catch let error as NSError {
                print(error)
            }
        }).resume()
    }
    
   
    

}

