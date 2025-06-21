//
//  Untitled.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-06-21.
//
import Foundation
import FirebaseAuth

class LogInViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var loggedIn = false
    
    init() {}
    
    func login() {
        guard validate() else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            errorMessage = "Please fill in all fields"
            
            return false
        }
        
        guard validEmail(string: email) else {
            errorMessage = "Please enter valid email"
            return false
        }
        
        loggedIn = true
        
        return true
    }
    
    func validEmail(string: String) -> Bool {
        let emailRegex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/.ignoresCase()
        return !string.ranges(of: emailRegex).isEmpty
    }

}
