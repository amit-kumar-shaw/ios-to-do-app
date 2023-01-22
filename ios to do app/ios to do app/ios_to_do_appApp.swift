//
//  ios_to_do_appApp.swift
//  ios to do app
//
//  Created by Cristi Conecini on 04.01.23.
//

import SwiftUI

@main
struct ios_to_do_appApp: App {
    
    
    
    let persistenceController = PersistenceController.shared
    
    @UIApplicationDelegateAdaptor(FirebaseAppDelegate.self) var delegate

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    NotificationUtility.schedule()
                }
        }
    }
}
