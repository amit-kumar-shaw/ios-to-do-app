//
//  FirebaseAppDelegate.swift
//  ios to do app
//
//  Created by Cristi Conecini on 16.01.23.
//

import Foundation
import SwiftUI
import FirebaseCore


class FirebaseAppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
