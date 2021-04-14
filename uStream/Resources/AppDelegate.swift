//
//  AppDelegate.swift
//  uStream
//
//  Created by stanley phillips on 2/18/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if UserDefaults.standard.value(forKey: "countryCode") == nil {
            UserDefaults.standard.setValue(Locale.current.regionCode, forKey: "countryCode")
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (authorized, error) in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
            }
            if authorized {
                UNUserNotificationCenter.current().delegate = self
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

// MARK: - Extensions
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.banner])
    }
}

