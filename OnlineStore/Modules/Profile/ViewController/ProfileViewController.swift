//
//  ProfileViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

final class ProfileViewController: BaseViewController {
    
    private var user = ProfileUser(name: "User Name", mail: "newuser@gmail.com", password: "12345678", repeatPassword: "12345678")
    
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
       CustomNavigationBarConfiguration(
        title: Text.profile,
        withSearchTextField: false,
        isSetupBackButton: false,
        rightButtons: [])
    }

    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
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
        showAlert(title: Text.doYouReallyWantToSignOutYourAccount, message: "")
    }
    
    private func finishPhotoEditing(photo: UIImage?) {
        user.photo = photo
        setupView()
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
          message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Text.cancel, style: .cancel))
        alertController.addAction(UIAlertAction(title: Text.signOut, style: .destructive
                                                , handler: { _ in
            print(">> Go to SIGN OUT flow")
            do {
                try AuthenticationManager.shared.signOut()
                //go to ondoarding + login flow
                let onboardingViewController = OnbordingViewController()
                let navVC = UINavigationController()
                navVC.navigationBar.isHidden = true
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                windowScene?.keyWindow?.rootViewController = navVC
                navVC.viewControllers = [onboardingViewController]
            } catch {
                print(">> Can't SIGN OUT of this user")
            }
        }))
        self.present(alertController, animated: true, completion: nil)
      }
}
