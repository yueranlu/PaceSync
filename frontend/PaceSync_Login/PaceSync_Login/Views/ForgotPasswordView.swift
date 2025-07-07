//
//  ForgotPasswordView.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-07-03.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var viewModel = ForgotPasswordViewViewModel()
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss

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
                    Text("Forgot your password?")
                        .font(.title)
                        .padding()
                        .offset(x: -25, y: -15)
                    
                    Text("Please enter the email address associated to your account")
                        .font(.subheadline)
                        .padding()
                        .offset(x: -6, y: -45)
                    
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .offset(y: -45)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    
                    Button("Send Email") {
                        Task {
                            do {
                                try await viewModel.forgotPassword(email: viewModel.email)
                            } catch {
                                print(error)
                            }
                        }
                    }
                    .foregroundColor(Color.white)
                    .bold()
                    .frame(width: 300, height: 50)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .offset(y: -35)
                    
                    Button("Back to Login") {
                        dismiss()
                    }
                    .foregroundColor(.black.opacity(0.5))
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black.opacity(0.6)),
                        alignment: .bottom
                    )
                    .offset(y: -15)
                    
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView(path: .constant(NavigationPath()))
}
