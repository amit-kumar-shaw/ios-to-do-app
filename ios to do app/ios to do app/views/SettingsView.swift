//
//  SettingsView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 16.01.23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var showEnableRemindersButton : Bool = false
    
    @AppStorage("tintColorHex") var tintColorHex: String = TINT_COLORS[0]
    
    init(){
        self.viewModel = SettingsViewModel()
    }
    
    
    var body: some View {
        ZStack{
            Form {
                Section {
                    Picker("Color Scheme", selection: $tintColorHex) {
                        ForEach(TINT_COLORS, id: \.self) { colorHex in
                            var tintColor = TintColor(colorHex: colorHex)
                            Text(tintColor.name).foregroundColor(tintColor.color)
                        }
                    }
                }
                
                Section{
                    Button("Log out", action: viewModel.signOut)
                        .foregroundColor(Color.red)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }}
        }.onAppear {
            NotificationUtility.hasPermissions(completion: {hasPermission in
                showEnableRemindersButton = !hasPermission
            } )
        }
    }
}
  
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
