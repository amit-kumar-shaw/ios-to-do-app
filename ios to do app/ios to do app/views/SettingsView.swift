//
//  SettingsView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 16.01.23.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack{
            Button("Log out", action: viewModel.signOut).buttonStyle(.bordered)
        }.navigationTitle("Settings")   
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
