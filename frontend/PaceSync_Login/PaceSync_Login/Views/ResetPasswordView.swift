//
//  ResetPasswordView.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-07-04.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject var viewModel = ResetPasswordViewViewModel()
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
                    Text("Reset your password")
                        .font(.title)
                        .padding()
                        .offset(x: -23, y: -20)
                    
                    SecureField("New Password", text: $viewModel.password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .offset(y: -25)
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
                        .offset(y: -25)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    
                    Button("Reset Password") {

                    }
                    .foregroundColor(Color.white)
                    .bold()
                    .frame(width: 300, height: 50)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .offset(y: -10)
                    
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
                    .offset(y: 0)
                
                }
            }
        }
    }
}

#Preview {
    ResetPasswordView(path: .constant(NavigationPath()))
}
