//
//  LoginScreen.swift
//  ios to do app
//
//  Created by Cristi Conecini on 16.01.23.
//

// Import the necessary modules
import SwiftUI
import FirebaseAuth

// Define the SignUpView struct
struct SignUpView: View {
    // State properties to store user inputs and status
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var error: String = ""
    @State private var isLoading = false
    @State private var isSuccess = false
    // Binding property to control the visibility of the sign up view
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
            // Display error message if there is any
            if (error != "") {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
            }
            // Sign up button
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
            .background(Color(hex:"#FFF9DA"))
    }
    // Function to handle the sign up process
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

// Define the ForgetPasswordView struct
struct ForgetPasswordView: View {
    // State properties to store user inputs and status
    @State private var email: String = ""
    @State private var error: String = ""
    @State private var isLoading = false
    @State private var isSuccess = false
    // Binding property to control the visibility of the forget password view
    @Binding var showForgetPasswordView: Bool
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
            // Display error message if there is any
            if (error != "") {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
            }
            // "Send reset email" button
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
            .background(Color(hex:"#FFF9DA"))
    }
    // Function to handle the password reset process
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

// Define the LoginScreen struct
struct LoginScreen: View {
    // State properties to store user inputs and status
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var error: String = ""
    @State private var isLoading = false
    @State private var isSuccess = false
    // State properties to control the visibility of the sign up and forget password views
    @State private var showSignUpView = false
    @State private var showForgetPasswordView = false

    var body: some View {
            VStack{
                Text("Log in").font(.largeTitle)
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                // Display error message if there is any
                if (error != "") {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                }
                // Login button
                Button("Login", action: {
                    self.login()
                })
                .padding()
                .disabled(isLoading)
                .opacity(isLoading ? 0.6 : 1)
                .buttonStyle(.borderedProminent)
                // Sign up button
                Button("Sign Up", action: {
                    self.showSignUpView = true
                })
                .padding()
                .buttonStyle(.bordered)
                // Forget password button
                Button("Forget password", action: {
                    self.showForgetPasswordView = true
                })
                .padding()
                .buttonStyle(.bordered)
            }.padding().textFieldStyle(.roundedBorder)
        }
    // Function to handle the login process
    func login() {
        self.error = ""
        self.isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            self.isLoading = false
            if error != nil {
                self.error = error!.localizedDescription
            }
            else {
                self.isSuccess = true
                // navigate to home view
            }
        }
    }
}
