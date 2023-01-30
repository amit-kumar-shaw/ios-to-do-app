//
//  AuthenticationViewModel.swift
//  ios to do app
//
//  Created by Cristi Conecini on 16.01.23.
//

import Foundation
import FirebaseAuth
import SwiftUI

class AuthenticationViewModel: ObservableObject {
    
    @Published var isAuthenticated = false;
    @Published var currentUser: User? = nil;
    
    var firAuth = Auth.auth()
    
    var authStateHandle: AuthStateDidChangeListenerHandle? = nil;
    
    init(){
        authStateHandle = firAuth.addStateDidChangeListener(listener)
    }
    
    private func listener(auth: Auth, user: User?)-> Void{
        //TODO: implement auth listener logic
        isAuthenticated = user != nil
        currentUser = user
    }
    
    deinit{
        if let authStateHandle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(authStateHandle)
        }
    }
}
