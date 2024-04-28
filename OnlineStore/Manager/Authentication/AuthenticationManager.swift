//
//  AuthenticationManager.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 27.04.2024.
//

import Foundation
import FirebaseAuth


struct AuthDataResultModel {
    let name: String?
    let uid: String
    let email: String?
    let photoUrl: String?

    init(user: User) {
        self.name = user.displayName
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


    func createUser(email: String, password: String, name: String) async throws -> AuthDataResultModel {
        let authDataResults = try await Auth.auth().createUser(withEmail: email, password: password)
        updateUserName(displayName: name)
        return AuthDataResultModel(user: authDataResults.user)

    }

    
    private func updateUserName(displayName: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges { (error) in
          // ... show alert if needed
        }
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

