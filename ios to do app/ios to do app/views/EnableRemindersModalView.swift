//
//  EnableRemindersModalView.swift
//  ios to do app
//
//  Created by Max on 21.01.23.
//

import Foundation
import SwiftUI

struct EnableRemindersModalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var didAskForNotifications : Bool = false
    @State private var appearanceCount : Int = 0
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                        
                    }.padding(30)
                    
                    Spacer()
                }
        
                Spacer()
                Text("🔔")
                    .font(.system(size: 100))
                    .multilineTextAlignment(TextAlignment.center)
                    .padding()
                
                Text("Never miss a due date again!")
                    .font(.title2)
                    .multilineTextAlignment(TextAlignment.center)
                    .padding()
                
                Text("We highly recommend that you enable notificationns. Get notified when it's time to complete your tasks by enabling reminders for our app.")
                    .multilineTextAlignment(TextAlignment.center)
                    
                    .padding()
                
                Spacer()
                
                Button(action: {
                    if (didAskForNotifications) {
                        NotificationUtility.openSettings()
                    } else {
                        NotificationUtility.askForNotificationPermissions()
                    }
                    dismiss()
                }) {
                    Text(!didAskForNotifications ? "Enable reminders" : "Open settings")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    if (appearanceCount > 2) {
                        NotificationUtility.setDontShowRemindersModal()
                    }
                    dismiss()
                    
                }) {
                    Text(appearanceCount > 2 ? "Don't show again" : "Not now")
                        .font(.subheadline)
                        .padding()
                }
            }.padding(10)

            

        }.onAppear {
            appearanceCount = NotificationUtility.getReminderModalAppearanceCount()
            didAskForNotifications = NotificationUtility.didAskForNotificationPermissions()
            NotificationUtility.incrementReminderModalAppearanceCount()
        }
    }
}

//struct EnableRemindersModalView_Previews: PreviewProvider {
  //  static var previews: some View {
    //    EnableRemindersModalView(modal: EnableRemindersModal())
  //  }
//}
