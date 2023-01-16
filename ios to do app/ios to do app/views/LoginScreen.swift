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
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            SecureField("Password", text: $password)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
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
            .buttonStyle(PlainButtonStyle())
        }
    }
    func signup() {
        self.error = ""
        self.isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            self.isLoading = false
            if error != nil {
                self.error = error!.localizedDescription
                print("Error signing up: \(String(describing: error))")
            } else {
                self.isSuccess = true
                // navigate to home view
                self.showSignUpView = false
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
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
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
            .buttonStyle(PlainButtonStyle())
        }
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
            TextField("Email", text: $email)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            SecureField("Password", text: $password)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
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
            .buttonStyle(BorderedButtonStyle())
            Button(action: {
                self.showSignUpView.toggle()
            }) {
                Text("Sign Up")
            }
            .padding()
            .buttonStyle(BorderedButtonStyle())
            Button(action: {
                self.showForgetPasswordView.toggle()
            }) {
                Text("Forget Password")
            }
            .padding()
            .buttonStyle(BorderlessButtonStyle())
        }
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
