//
//  AppDelegate.swift
//  Ray
//
//  Created by Laureen Schausberger on 31.01.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

import Firebase
import GoogleMaps
import PopupDialog

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyCwW2A6ZbBrbEJ_CmhAIDo6UWBBe9e3rlU")

        if let userID = UserDefaults.standard.string(forKey: "userID") {
            showTabBarController(forUserID: userID)
            
        } else {
            showLoginViewController()
        }
        
        
        return true
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

    private func showLoginViewController() {
        DispatchQueue.main.async {
            if let loadingVC = self.window?.rootViewController as? LoadingViewController {
                loadingVC.stopIndicator()
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "loginNavigationController") as! UINavigationController
                self.window?.rootViewController = navigationController
            }
        }
    }
    
    func showTabBarController(forUserID userID: String) {
        DataHandler.shared.fetchUserInformation(forUserID: userID) { success, _ in
            
            guard success else {
                print("AppDelegate > Couldn't retrieve/find user.")
                return
            }
            
            DispatchQueue.main.async {
                if let loadingVC = self.window?.rootViewController as? LoadingViewController {
                    loadingVC.stopIndicator()
                }
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                self.window?.rootViewController = navigationController
                
            }
        }
    }
}
