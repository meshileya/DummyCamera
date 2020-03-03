//
//  AppDelegate.swift
//  DummyCameraWithFilter
//
//  Created by Israel Meshileya on 03/03/2020.
//  Copyright © 2020 Israel. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    var window: UIWindow?
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        self.window?.rootViewController = MainViewController()

        application.registerForRemoteNotifications()
        
        return true
    }


}

