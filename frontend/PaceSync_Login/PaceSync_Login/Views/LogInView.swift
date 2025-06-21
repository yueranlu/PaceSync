//
//  ContentView.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-06-09.
//

import SwiftUI

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
                        .offset(y: -180)
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .offset(y: -65)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .offset(y: -65)
                        .border(.red, width: CGFloat(wrongPassword))
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    Text("OR")
                        .foregroundColor(.black.opacity(0.8))
                        .offset(y: 130)
                    
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
                    .offset(y: -45)
                    
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
                        .offset(y: -20)
                    
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
                    .offset(x: 135, y: -540)
                    
                    
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
