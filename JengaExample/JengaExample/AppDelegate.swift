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
        JengaEnvironment.isEnabledLog = true
        JengaEnvironment.setup(JengaProvider())
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

struct JengaProvider: Jenga.JengaProvider {
    
    func defaultTableView(with frame: CGRect) -> UITableView {
        let tableView: UITableView
        if #available(iOS 13.0, *) {
            // https://github.com/JarhomChen/TableViewOfInsetGrouped
            tableView = UITableView(frame: frame, style: .insetGrouped)
        } else {
            tableView = UITableView(frame: frame, style: .grouped)
        }
        return tableView
    }
}

/// 扩展TextValues属性
extension TextValues {
    
    var edgeInsets: UIEdgeInsets {
        get { self[option: EdgeInsetKey.self] }
        set { self[option: EdgeInsetKey.self] = newValue }
    }
    
    private struct EdgeInsetKey: TextKey {
        static let defaultValue: UIEdgeInsets = .zero
        
        static func perform(with label: UILabel?, didChanged textValues: UIEdgeInsets) {
            label?.edgeInsets = textValues
        }
    }
}
