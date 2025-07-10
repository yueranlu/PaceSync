//
//  Untitled.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-06-21.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

class LogInViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var loggedIn: Bool = false
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func login(withEmail email: String, password: String) async throws {
        guard try await validate() else {
            return
        }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            await MainActor.run {
                self.userSession = result.user
            }
            await fetchUser()
            print("Logged in successfully!")
            await MainActor.run {
                loggedIn = true
            }
        } catch {
            await MainActor.run {
                loggedIn = false
            }
            print("Failed to log in: \(error.localizedDescription)")
        }
    }
    
    
    private func validate() async throws -> Bool {
        await MainActor.run {
            errorMessage = ""
        }
        
        guard isValidPassword, !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            errorMessage = "Please fill in all fields"
            
            return false
        }
        
        guard validEmail(string: email) else {
            errorMessage = "Please enter valid email"
            return false
        }
        
        
        return true
    }
    
    private var isValidPassword: Bool {
        password.trimmingCharacters(in: .whitespaces).count >= 8
    }
    
    var canLogIn: Bool {
        validEmail(string: email) && isValidPassword && !email.isEmpty && !password.isEmpty
    }
    
    func validEmail(string: String) -> Bool {
        let emailRegex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/.ignoresCase()
        return !string.ranges(of: emailRegex).isEmpty
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        await MainActor.run {
            self.currentUser = try? snapshot.data(as: User.self)
        }
    }
}
