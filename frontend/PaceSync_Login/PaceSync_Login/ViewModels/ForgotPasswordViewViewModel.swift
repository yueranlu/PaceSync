//
//  ForgotPasswordViewViewModel.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-07-03.
//

import Foundation
import FirebaseAuth

class ForgotPasswordViewViewModel: ObservableObject {
    @Published var email = ""
    
    func forgotPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
