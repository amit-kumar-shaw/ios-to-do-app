//
//  SettingsView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 16.01.23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()
    
    var body: some View {
        ZStack{
            Form {
                Section {
                    Picker("Color Scheme", selection: $viewModel.settings.selectedColorScheme) {
                        ForEach(ColorSchemeOption.allCases, id: \.self) { colorScheme in
                            Text(colorScheme.rawValue)
                        }
                    }.onChange(of: viewModel.settings.selectedColorScheme) { value in
                        viewModel.settings.selectedColorScheme = value
                        viewModel.save()
                    }.foregroundColor(ios_to_do_app.colorScheme(for: viewModel.settings.selectedColorScheme).primary)
                }
                Section{
                    Button("Log out", action: viewModel.signOut)
                        .foregroundColor(Color.red)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }}
        }
    }
}
  
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
private func colorScheme(for colorScheme: ColorSchemeOption) -> ColorScheme {
    switch colorScheme {
    case .defaultColor:
        return ColorScheme(primary: .black, secondary: .gray, accent: .blue, background: Color.white, text: .black, error: .red)
    case .blue:
        return ColorScheme(primary: .blue, secondary: .white, accent: .orange, background: Color.black, text: .white, error: .red)
    case .green:
        return ColorScheme(primary: .green, secondary: .white, accent: .purple, background: Color.white, text: .white, error: .red)
    case .pink:
        return ColorScheme(primary: .pink, secondary: .white, accent: .yellow, background: Color.white, text: .white, error: .red)
    }
}
