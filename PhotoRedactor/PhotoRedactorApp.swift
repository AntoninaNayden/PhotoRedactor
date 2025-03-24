//
//  PhotoRedactorApp.swift
//  PhotoRedactor
//
//  Created by Antonina on 22.03.25.
//

import SwiftUI
import Firebase
import UIKit
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

@main
 struct PhotoRedactorApp: App {
      @StateObject var authManager = AuthManager()
      @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
      
      var body: some Scene {
          WindowGroup {
              ContentView()
                  .environmentObject(authManager)
          }
      }
  }

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        configureFirebase()
        return true
    }

    private func configureFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            print("Firebase успешно сконфигурирован!")
        }
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        if Auth.auth().canHandle(url) {
            print("Firebase Link handled: \(url)")
            return true
        }

        if GIDSignIn.sharedInstance.handle(url) {
            print("Google SignIn handled: \(url)")
            return true
        }

        return false
    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        if let url = userActivity.webpageURL {
            if Auth.auth().canHandle(url) {
                print("Firebase Universal Link handled: \(url)")
                return true
            }
        }
        return false
    }
}
