//
//  SettingsViewModel.swift
//  ios to do app
//
//  Created by Cristi Conecini on 16.01.23.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Combine




class SettingsViewModel: ObservableObject {
    @Published var error: Error? = nil
    private var firAuth = Auth.auth()
    private var cancelables: [AnyCancellable] = []

    func signOut(){
        do {
            try firAuth.signOut()
        } catch {
            print("Error signing out", error)
            self.error = error
        }
    }
    
}
