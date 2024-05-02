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
        getUserRoleWithID()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    private func getUserRoleWithID(){
        StoreManager.shared.getUserRole(forKey: .userRoleID) { role in
            guard role != nil else {
                print("Set Default Role User")
                StoreManager.shared.saveUserRole(Text.roleUser, forKey: .userRoleID) // сохраняем для существующих пользователей(аккаунты до доавления смены роли для пользователя), или для пользователей, которые не выбрали роль при регистрации  роль по умолчанию - User с учетом их id
                return
            }
        }
    }
    
    private func setupView() {
        let profileView = ProfileView(user: CurentUser())
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
        let actionSheet = UIAlertController(title: "Select Account Type", message: nil, preferredStyle: .actionSheet)
        let managerAction = UIAlertAction(title: "Manager",  style: .default) { _ in
            let managerAlert = UIAlertController(title: "Manager Account", message: "Enter Manager Password", preferredStyle: .alert)
            
            managerAlert.addTextField { textField in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
                let password = managerAlert.textFields?.first?.text ?? ""
                if password == Text.managerPassword{
                    print("correct password")
                    self.saveNewRoleForUser(role: Text.roleManager)// сохранить роль Manager и после проверку есть в таб баре манеджер
                } else {
                    let errorAlert = UIAlertController(title: "Error", message: "Incorrect Manager Password", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "OK", style: .cancel)
                    errorAlert.addAction(cancel)
                    self.present(errorAlert, animated: true)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            managerAlert.addAction(submitAction)
            managerAlert.addAction(cancelAction)
            
            self.present(managerAlert, animated: true)
        }
        
        let userAction = UIAlertAction(title: "User", style: .default) { _ in
            self.saveNewRoleForUser(role: Text.roleUser)// сохранить роль User и после проверку есть в таб баре манеджер
        }
        
        actionSheet.addAction(managerAction)
        actionSheet.addAction(userAction)
        
        present(actionSheet, animated: true)
    }
    
    private func saveNewRoleForUser(role: String){
        StoreManager.shared.saveUserRole(role, forKey: .userRoleID)
        if let tabBar = self.tabBarController as? CustomTabBar {
            tabBar.updateTabBarAccordingUserRole()
        }
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
        if let profileView = view as? ProfileView {
            profileView.setupImage(photo)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
                                                    message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Text.cancel, style: .cancel))
        alertController.addAction(UIAlertAction(title: Text.signOut, style: .destructive
                                                , handler: { _ in
            print(">> Go to SIGN OUT flow")
            AuthenticationManager.shared.setUserRoleWhenRegistration(role: "") // чистим роль текущего пользователя в AuthenticationManager, чтобы при смене аккаунта не подтягивалась роль предыдущего пользователя в методе reSaveUserRoleWithID() в СustomTabBar
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
    
    private func getCurrentUser() -> AuthDataResultModel? {
        var currentUser: AuthDataResultModel?

        do {
            currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
            if let email = currentUser?.email {
                print("Authenticated user: \(email)")
            } else {
                print("No email available")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return currentUser
    }
    
    private func CurentUser() -> ProfileUser {
        let data = getCurrentUser()
        return ProfileUser(name: data?.name, mail: (data?.email)!, password: "12345678", repeatPassword: "12345678")
    }
}
