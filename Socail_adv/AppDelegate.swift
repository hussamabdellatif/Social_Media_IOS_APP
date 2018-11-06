//
//  AppDelegate.swift
//  Socail_adv
//
//  Created by Hussam Abdellatif on 1/7/18.
//  Copyright © 2018 Hussam Abdellatif. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import TwitterKit
import GoogleSignIn
import GoogleAPIClientForREST
import GoogleMaps
import GooglePlaces
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate   {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        TWTRTwitter.sharedInstance().start(withConsumerKey:"lf7zh7Ek00MhIPRA8AbANLCSl", consumerSecret:"Dp8rJoIy32VXvVhqVvW6JE8MaOxo1cIKS8P5qKW1qc0ruWK9xj")
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID  //"166715456120-bcoabu4daao8lr3re55p8skd82q67qte.apps.googleusercontent.com"
        GMSServices.provideAPIKey("AIzaSyBi1Uev-dNEEC1lDugvCVQNUxCqwiE3CzM")
        GMSPlacesClient.provideAPIKey("AIzaSyBi1Uev-dNEEC1lDugvCVQNUxCqwiE3CzM" )
        return true
    }
   
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> (Bool) {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        let twitterlogin = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        let google_sign =  GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication,annotation: annotation)
        return handled || twitterlogin || google_sign
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

