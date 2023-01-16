//
//  ContentView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 16.01.23.
//

import SwiftUI

struct ContentView: View {
    
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
