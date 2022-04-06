//
//  AppDelegate.swift
//  JengaExample
//
//  Created by 方林威 on 2022/3/30.
//

import UIKit
import Jenga

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        JengaProvider.setup()
        
        JengaProvider.autoTable { frame in
            let tableView: UITableView
            if #available(iOS 13.0, *) {
                tableView = UITableView(frame: frame, style: .insetGrouped)
            } else {
                tableView = UITableView(frame: frame, style: .grouped)
            }
            tableView.separatorStyle = .none
            return tableView
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

