//
//  AuthenticationManager.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 21.04.2024.
//

import Foundation
import FirebaseAuth


struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
      
    }
}


final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    
    private init() {}
    
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResults = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResults.user)
        
    }
    
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    
    func resetPassword(with email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
