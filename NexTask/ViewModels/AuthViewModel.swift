//
//  AuthViewModel.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-24.
//

import Combine
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    @Published var user: User?
    
    private let service = AuthService()
    
    init() {
        self.user = Auth.auth().currentUser
        self.isLoggedIn = user != nil
    }
    
    func login(email: String, password: String) async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        do {
            let user = try await service.login(email: email, password: password)
            self.user = user
            self.isLoggedIn = true
            self.errorMessage = nil
        } catch {
            self.errorMessage = mapError(error)
            print("Login error:", error.localizedDescription)
        }
    }
    
    func register(email: String, password: String, confirmPassword: String) async {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        do {
            let user = try await service.register(email: email, password: password)
            self.user = user
            self.isLoggedIn = true
        } catch {
            self.errorMessage = mapError(error)
            print("Register error:", error.localizedDescription)
        }
    }
    
    func logout() {
        do {
            try service.logout()
            self.user = nil
            self.isLoggedIn = false
        } catch {
            print("Logout error:", error.localizedDescription)
        }
    }
    
    private func mapError(_ error: Error) -> String {
        let nsError = error as NSError
        
        switch nsError.code {
        case AuthErrorCode.wrongPassword.rawValue:
            return "Incorrect password"
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email format"
        case AuthErrorCode.userNotFound.rawValue:
            return "No account found for this email"
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "This email is already registered"
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email format"
        case AuthErrorCode.weakPassword.rawValue:
            return "Password must be at least 6 characters"
        case AuthErrorCode.networkError.rawValue:
            return "Network error. Please try again"
        default:
            return "Request failed. Please try again"
        }
    }
}
