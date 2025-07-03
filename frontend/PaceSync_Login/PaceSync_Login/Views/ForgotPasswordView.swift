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
                    
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView(path: .constant(NavigationPath()))
}
