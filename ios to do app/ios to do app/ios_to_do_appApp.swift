//
//  ios_to_do_appApp.swift
//  ios to do app
//
//  Created by Cristi Conecini on 04.01.23.
//

import SwiftUI
import FirebaseCore
import Combine

@main
struct ios_to_do_appApp: App {
    
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(FirebaseAppDelegate.self) var delegate

    @AppStorage("tintColorHex") var tintColorHex = TINT_COLORS[0]
    
    @State private var showEnableRemindersModal : Bool = false
    
    func schedule(tintColor: String) {
        Task {
            await RemindersWidgetUtility.scheduleRemindersAndWidgetTimeline(tintColor: tintColor)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(tintColor: Color(hex: tintColorHex))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.tintColor, Color(hex: tintColorHex))
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    schedule(tintColor: tintColorHex)
                }
                .onAppear {
                    RemindersWidgetUtility.hasPermissions(completion: { hasPermissions in
                        if !hasPermissions, !RemindersWidgetUtility.getDontShowRemindersModal() {
                            self.showEnableRemindersModal = true
                        }
                    })
                }
                .fullScreenCover(isPresented: $showEnableRemindersModal) {
                    EnableRemindersModalView().tint(Color(hex: tintColorHex)).environment(\.tintColor, Color(hex: tintColorHex))
                }
        }
    }
}
