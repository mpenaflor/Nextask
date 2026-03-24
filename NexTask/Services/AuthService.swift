//
//  AuthService.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-24.
//

import FirebaseAuth

final class AuthService {
    
    func getValidToken() async throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.userAuthenticationRequired)
        }
        return try await user.getIDToken()
    }
    
    func login(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        let token = try await result.user.getIDToken()
        print("token: \(token)")
        return result.user
    }
    
    func register(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
}
