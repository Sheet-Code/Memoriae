//
//  AppDelegate.swift
//  Memoriae
//
//  Created by panandafog on 31.03.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let repo = ScoreRepositoryImpl()
        if repo.count() == 0 {
            repo.clear()
        }

        UINavigationBar.appearance().tintColor = ColorScheme.tintColor
        UIToolbar.appearance().tintColor = ColorScheme.tintColor
        UISlider.appearance().tintColor = ColorScheme.tintColor
        UITabBar.appearance().tintColor = ColorScheme.tintColor
        UIButton.appearance().tintColor = ColorScheme.tintColor
        UIProgressView.appearance().tintColor = ColorScheme.tintColor

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
