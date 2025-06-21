//
//  RegistrationViewViewModel.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-06-21.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    init() {}
    
    func register() {
        guard validate() else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let userId = result?.user.uid else {
                return
            }
            
            self?.insertUserRecord(id: userId)
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id, username: username, email: email, joined: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool {
        guard isValidEmail, isValidPassword, !username.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        return true
    }
    
    private var isValidEmail: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && validEmail(string: email)
    }
    
    private var isValidPassword: Bool {
        password.trimmingCharacters(in: .whitespaces).count >= 8
    }
    
    var canCreateAccount: Bool {
        isValidEmail &&
        isValidPassword &&
        !username.trimmingCharacters(in: .whitespaces).isEmpty &&
        passwordsMatch
    }
    
    func validEmail(string: String) -> Bool {
        let emailRegex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/.ignoresCase()
        return !string.ranges(of: emailRegex).isEmpty
    }

    var passwordsMatch: Bool {
        return password == confirmPassword && !confirmPassword.isEmpty
    }
}
