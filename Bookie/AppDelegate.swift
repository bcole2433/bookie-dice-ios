//
//  AppDelegate.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/11/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        super.init()
        FirebaseApp.configure()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if !UserDefaults.standard.bool(forKey: "HasLaunchedOnce") {
            print ("app launched for first time")
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            
        }
        
       let db = Firestore.firestore()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
 
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
   
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

