//
//  AppDelegate.swift
//  AnimaExample
//
//  Created by Satoshi Nagasaka on 2017/03/09.
//  Copyright © 2017年 satoshin21. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        let navAppearance = UINavigationBar.appearance()
        navAppearance.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navAppearance.barTintColor = .navigationBar
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
        UITableView.appearance().backgroundColor = .background
        
        UIButton.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}

