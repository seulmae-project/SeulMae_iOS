//
//  AppDelegate.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import RxKakaoSDKCommon
import CoreData
import NMapsMap
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        RxKakaoSDK.initSDK(appKey: Bundle.main.nativeAPPKey) 
        NMFAuthManager.shared().clientId = Bundle.main.naverClientId
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            .font: UIFont.pretendard(size: 16, weight: .semibold),
            .foregroundColor: UIColor.ext.hex("2B2B2C"),
        ]
        // navBarAppearance.standardAppearance.titlePositionAdjustment = .zero
        // navBarAppearance.
        let appearance = UINavigationBarAppearance()

        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()

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

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let _deviceToken = deviceToken
            .map { String(format: "%02.2hhx", $0) }
            .joined()
        Swift.print("deviceToken: ", _deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async -> UIBackgroundFetchResult {
        return UIBackgroundFetchResult.newData
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {

    // MARK: - UNUserNotificationCenterDelegate

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let title = notification.request.content.title
        let body = notification.request.content.body

        var userInfo = notification.request.content.userInfo
        userInfo["title"] = title
        userInfo["body"] = body

        return [.banner, .badge, .sound]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        _ = response.notification.request.content.userInfo
    }

    // MARK: - MessagingDelegate

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // TODO: If necessary send token to application server.
        if let fcmToken {
            Swift.print("fcmToken: \(fcmToken)")
            UserDefaults.standard.setValue(fcmToken, forKey: "fcmToken")
        }
    }

    private func fetchingCurrentRegistrationToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }
}





