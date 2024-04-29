//
//  AuthenticationManager.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 16.04.24.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct AuthDataResultModel {
    let uid: String
    let name: String?
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.name = user.displayName
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()  // Added Firestore reference
    
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
        changeRequest?.commitChanges { error in
            // Handle errors or updates here if needed
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
    
    // Upload image function integrated
    func uploadImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.4),
              let userId = Auth.auth().currentUser?.uid else { return }

        let storageRef = storage.child("profileimages/\(userId).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                // Handle the error: update UI or notify the user
                return
            }

            storageRef.downloadURL { [weak self] url, error in
                guard let downloadURL = url else {
                    
                    return
                }

                self?.db.collection("users").document(userId).updateData(["profileImageUrl": downloadURL.absoluteString]) { error in
                    if let error = error {
                        
                    } else {
    
                    }
                }
            }
        }
    }
}
