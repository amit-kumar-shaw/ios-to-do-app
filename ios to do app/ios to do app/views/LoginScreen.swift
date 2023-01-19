//
//  LoginScreen.swift
//  ios to do app
//
//  Created by Cristi Conecini on 16.01.23.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var error: String = ""
    @State private var isLoading = false
    @State private var isSuccess = false
    @Binding var showSignUpView: Bool
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    var body: some View {
        VStack {
            Text("Create Account").font(.largeTitle)
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            if (error != "") {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
            }
            Button(action: {
                self.signup()
            }) {
                Text("Sign Up")
            }
            .padding()
            .disabled(isLoading)
            .opacity(isLoading ? 0.6 : 1)
            .buttonStyle(.borderedProminent)
        }.padding().textFieldStyle(.roundedBorder)
    }
    func signup() {
        self.error = ""
        self.isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            self.isLoading = false
            if error != nil {
                withAnimation{
                    self.error = error!.localizedDescription
                }
                print("Error signing up: \(String(describing: error))")
            } else {
                self.isSuccess = true
                // navigate to home view
                //self.showSignUpView = false
                Auth.auth().signIn(withEmail: email, password: password)
            }
        }
    }
}

struct ForgetPasswordView: View {
    @State private var email: String = ""
    @State private var error: String = ""
    @State private var isLoading = false
    @State private var isSuccess = false
    @Binding var showForgetPasswordView: Bool
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
            if (error != "") {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
            }
            Button(action: {
                self.forgotPassword()
            }) {
                Text("Send Reset Email")
            }
            .padding()
            .disabled(isLoading)
            .opacity(isLoading ? 0.6 : 1)
            .buttonStyle(.bordered)
        }.padding().textFieldStyle(.roundedBorder)
    }
    func forgotPassword() {
        self.error = ""
        self.isLoading = true
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            self.isLoading = false
            if error != nil {
                self.error = error!.localizedDescription
            }
            else {
                self.isSuccess = true
                self.showForgetPasswordView = false
            }
        }
    }
}

struct LoginScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var error: String = ""
    @State private var isLoading = false
    @State private var isSuccess = false
    @State private var showSignUpView = false
    @State private var showForgetPasswordView = false

    var body: some View {
        VStack {
            Text("Log in").font(.largeTitle)
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            if (error != "") {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
            }
            Button("Login", action: {
                self.login()
            })
            .padding()
            .disabled(isLoading)
            .opacity(isLoading ? 0.6 : 1)
            .buttonStyle(.borderedProminent)
            Button(action: {
                self.showSignUpView.toggle()
            }) {
                Text("Sign Up")
            }
            .padding()
            .buttonStyle(.bordered)
            Button(action: {
                self.showForgetPasswordView.toggle()
            }) {
                Text("Forget Password")
            }
            .padding()
            .buttonStyle(.borderless)
        }.textFieldStyle(.roundedBorder).padding()
        .sheet(isPresented: $showSignUpView) {
            SignUpView(showSignUpView: self.$showSignUpView)
        }
        .sheet(isPresented: $showForgetPasswordView) {
            ForgetPasswordView(showForgetPasswordView: self.$showForgetPasswordView)
        }
    }
    func login() {
        self.error = ""
        self.isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            self.isLoading = false
            if error != nil {
                self.error = error!.localizedDescription
            } else {
                self.isSuccess = true
                // navigate to home view
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}


/*
import Firebase
import SwiftUI

struct AuthenticationView: View {
   
}
*/
