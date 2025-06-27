//
//  ContentView.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-06-09.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import Firebase

struct LogInView: View {
    @StateObject var viewModel = LogInViewViewModel()
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var path = NavigationPath()
    
    //reminder: logo should go somewhere in the front
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.gray.opacity(0.15)
                    .ignoresSafeArea()
                Rectangle()
                    .frame(width: 350, height: 300)
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
                    .offset(y: -10)
                VStack {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .offset(y: -10)
                    }
                    
                    Text("Log In to PaceSync")
                        .font(.title)
                        .bold()
                        .padding()
                        .offset(y: -150)
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .offset(y: -15)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .offset(y: -15)
                        .border(.red, width: CGFloat(wrongPassword))
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    Text("OR")
                        .foregroundColor(.black.opacity(0.8))
                        .offset(y: 150)
                    
                    Button("Log in") {
                        viewModel.login()
                        
                        if viewModel.loggedIn {
                            path.append("loggedIn")
                        }
                    }
                    .foregroundColor(Color.white)
                    .bold()
                    .frame(width: 300, height: 50)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .offset(y: -10)
                    
                    Button("Forgot Password?") {
                        path.append("forgotPassword")
                    }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.black.opacity(0.6)),
                            alignment: .bottom
                        )
                        .foregroundColor(.black.opacity(0.6))
                        .offset(y: 10)
                    
                    Button("Register") {
                        path.append("register")
                    }
                    .font(.headline)
                    .foregroundColor(.black.opacity(0.6))
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black.opacity(0.6)),
                        alignment: .bottom
                    )
                    .offset(x: 135, y: -530)
                    
                    GoogleButton {
                        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

                        // Create Google Sign In configuration object.
                        let config = GIDConfiguration(clientID: clientID)
                        GIDSignIn.sharedInstance.configuration = config

                        // Start the sign in flow!
                        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { signResult, error in
                            
                          if let error = error {
                              return
                          }

                          guard let user = signResult?.user,
                                let idToken = user.idToken
                                
                          else {
                              return
                          }
                            
                            let accessToken = user.accessToken
                            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                                         accessToken: accessToken.tokenString)
                            
                            Auth.auth().signIn(with: credential) { authResult, error in

                            }
                            
                            UserDefaults.standard.set(true, forKey: "loggedIn")

                        }
                        

                    }
                    .offset(y: 40)
                    
//                    Button("Sign Out & Clear Cache") {
//                        GIDSignIn.sharedInstance.signOut()
//                        try? Auth.auth().signOut()
//                        print("✅ Signed out and cleared cache")
//                    }
                    
                    }
                }
            .navigationBarHidden(true)
            
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "loggedIn":
                    HomepageView()
                case "forgotPassword":
                    Text("temporary")
                case "register":
                    RegistrationView(path: $path)
                default:
                    Text("Nothing")
                }
            }
        }
    }
    
    
}

#Preview {
    LogInView()
}
