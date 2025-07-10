//
//  ResetPasswordViewViewModel.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-07-04.
//

import Foundation
import FirebaseAuth

class ResetPasswordViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    var passwordsMatch: Bool {
        return password == confirmPassword && !confirmPassword.isEmpty
    }
    
    private var isValidPassword: Bool {
        password.trimmingCharacters(in: .whitespaces).count >= 8
    }
    
    var canResetPassword: Bool {
        passwordsMatch && isValidPassword
    }
    

}
