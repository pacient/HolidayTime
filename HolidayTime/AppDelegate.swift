//
//  AppDelegate.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        Fabric.with([Crashlytics.self])
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9037734016404410~5700632488")
        UIApplication.shared.statusBarStyle = .lightContent
        
        if UserDefaults.standard.object(forKey: Const.firstLaunch) == nil {
            UserDefaults.standard.set(true, forKey: Const.firstLaunch)
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (allowed, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

