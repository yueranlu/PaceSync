//
//  RegistrationView.swift
//  
//
//  Created by Dongshen Guan on 2025-06-14.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewViewModel()
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss
    
    //reminder: logo should go somewhere in the front
    var body: some View {
        ZStack {
                Color.gray.opacity(0.15)
                    .ignoresSafeArea()
                Rectangle()
                    .frame(width: 350, height: 400)
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
                    .offset(y: -10)
                VStack {
                    Text("Register to PaceSync")
                        .font(.title)
                        .bold()
                        .padding()
                        .offset(y: -180)
                    
                    VStack {
                        
                        TextField("Username", text: $viewModel.username)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .offset(y: -60)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                        
                        TextField("Email", text: $viewModel.email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .offset(y: -60)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .offset(y: -45)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                        
                        SecureField("Confirm Password", text: $viewModel.confirmPassword)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewModel.confirmPassword.isEmpty ? Color.clear : (viewModel.passwordsMatch ? Color.green : Color.red), lineWidth: 2)
                            )
                            .offset(y: -45)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                    }
                    
                    Button("Create Account") {
                        if viewModel.canCreateAccount {
                            viewModel.register()
                            path.append("loggedIn")
                        }
                    }
                    .foregroundColor(Color.white)
                    .bold()
                    .frame(width: 300, height: 50)
                    .background(viewModel.canCreateAccount ? Color.gray.opacity(0.9) : Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .offset(y: -15)
                    .disabled(!viewModel.canCreateAccount)
                    
                    Button("Already have an account? Sign in!") {
                        dismiss()
                    }
                    .foregroundColor(.black.opacity(0.5))
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black.opacity(0.6)),
                        alignment: .bottom
                    )
                    .offset(y: -10)
                    
                    }
                }	
            .navigationBarHidden(true)

    }
    
    
}

#Preview {
    RegistrationView(path: .constant(NavigationPath()))
}
