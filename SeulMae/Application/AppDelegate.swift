//
//  AppDelegate.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import RxKakaoSDKCommon
import CoreData


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        RxKakaoSDK.initSDK(appKey: Bundle.main.nativeAPPKey) 
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            .font: UIFont.pretendard(size: 20, weight: .bold),
            .foregroundColor: UIColor.label,
        ]
        // navBarAppearance.standardAppearance.titlePositionAdjustment = .zero
        // navBarAppearance.
        let appearance = UINavigationBarAppearance()
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

