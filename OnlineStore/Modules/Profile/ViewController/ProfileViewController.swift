//
//  ProfileViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var user = User(name: "User Name", mail: "newuser@gmail.com", password: "12345678")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
    }
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    private func setupView() {
        let profileView = ProfileView(user: user)
        profileView.onEditPhotoTap = goToPhotoEdit
        profileView.onAccountTypeTap = goToAccountType
        profileView.onTermsTap = goToTerms
        profileView.onSignOutTap = signOut
        view = profileView
    }
    
    
    private func goToPhotoEdit() {
        let photoEditVC = PhotoEditViewController()
        photoEditVC.modalPresentationStyle = .overFullScreen
        photoEditVC.onChoiceMade = finishPhotoEditing(photo:)
        present(photoEditVC, animated: true)
    }
    
    private func goToAccountType() {
        
    }
    
    private func goToTerms() {
        let termsVC = TermsViewController()
        termsVC.modalPresentationStyle = .fullScreen
        present(termsVC, animated: true)
    }
    
    private func signOut() {
        
    }
    
    private func finishPhotoEditing(photo: UIImage?) {
        user.photo = photo
        setupView()
    }
}
