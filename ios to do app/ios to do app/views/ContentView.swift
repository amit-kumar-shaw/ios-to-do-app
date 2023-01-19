//
//  ContentView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 16.01.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = SettingsViewModel()
    @StateObject var autheniticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        if(autheniticationViewModel.isAuthenticated){
            HomeView()
        }else{
            LoginScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private func colorScheme(for colorScheme: ColorSchemeOption) -> ColorScheme {
    switch colorScheme {
    case .defaultColor:
        return ColorScheme(primary: .black, secondary: .gray, accent: .blue, background: .white, text: .black, error: .red)
    case .blue:
        return ColorScheme(primary: .blue, secondary: .white, accent: .orange, background: .white, text: .white, error: .red)
    case .green:
        return ColorScheme(primary: .green, secondary: .white, accent: .purple, background: .white, text: .white, error: .red)
    case .pink:
        return ColorScheme(primary: .pink, secondary: .white, accent: .yellow, background: .white, text: .white, error: .red)
    }
}
