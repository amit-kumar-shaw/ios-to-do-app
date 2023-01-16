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
//    @Published var showAlert = false;
//    @Published var error: Error? = nil;
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
    
//    func login(email: String, password: String){
//        firAuth.signIn(withEmail: email, password: password){res,err in
//            if (err != nil) {
//                self.error = err
//                self.showAlert = true
//            }else{
//                print("Signed in sucessfully")
//            }
//        }
//    }
//
//    func signUp(email: String, password: String){
//        firAuth.createUser(withEmail: email, password: password){
//            res,err in
//            if (err != nil) {
//                self.error = err
//                self.showAlert = true
//            }else{
//                print("Created account sucessfully")
//            }
//        }
//    }
//
//    func clearError(){
//        showAlert = false
//        error = nil
//    }
//
//    func logOut(){
//        do{
//            try firAuth.signOut()
//        }catch{
//            self.error = error
//            self.showAlert = true
//        }
//    }
    
    deinit{
        if let authStateHandle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(authStateHandle)
        }
    }
}
