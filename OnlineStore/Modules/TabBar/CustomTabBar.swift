//
//  CustomTabBar.swift
//  OnlineStore
//
//  Created by Polina on 16.04.2024.
//

import UIKit

final class CustomTabBar: UITabBarController {
    
    private var previousSelectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reSaveUserRoleWithID()
        setTabBarAppearence()
        generateTabBar()
        updateTabBarAccordingUserRole()
    }
    
    private func generateTabBar(){
        let homeVC = HomeViewController()
        let navHome = UINavigationController(rootViewController: homeVC)
        let wishListVC = WishListViewController()
        let navWish = UINavigationController(rootViewController: wishListVC)
        let managerVC = ManagerViewController()
        let navManager = UINavigationController(rootViewController: managerVC)
        let profileVC = ProfileViewController()
        let navProfile = UINavigationController(rootViewController: profileVC)
        setUPVC(title: "Home", image: "Home", selectedImage: "HomeTapped", vc: homeVC)
        setUPVC(title: "Wishlist", image: "Heart", selectedImage: "HeartTapped", vc: wishListVC)
        setUPVC(title: "Manager", image: "Paper", selectedImage: "PaperTapped", vc: managerVC)
        setUPVC(title: "Account", image: "Profile", selectedImage: "ProfileTapped", vc: profileVC)
        self.setViewControllers([navHome, navWish, navManager, navProfile], animated: false)
    }
    
    private func setUPVC( title: String, image: String, selectedImage: String, vc: UIViewController){
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage(named: image)
        vc.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
    }
    
    private func setTabBarAppearence(){
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = UIColor(named: "CustomGreen")
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        self.tabBar.layer.borderWidth = 0.5
    }
    
    private func reSaveUserRoleWithID(){ // пересохраняем роль с id пользователя после прохождения регистрации, если пользователь не регистрировался а просто вошел в существующий аккаунт, то данная функция не отработает, а в ProfileVC мы сразу будет получать роль с учетом id пользователя
        let userRole = AuthenticationManager.shared.getUserRoleAfterRegistration()
        if !userRole.isEmpty{
            print("Save user Role after Registration")
            StoreManager.shared.saveUserRole(userRole, forKey: .userRoleID)
        }
    }
    
   func updateTabBarAccordingUserRole(){
        let managerTab = viewControllers?.firstIndex { $0.tabBarItem.title == "Manager" }
        StoreManager.shared.getUserRole(forKey: .userRoleID) { roleWithId in
            if roleWithId == Text.roleManager{
                if managerTab == nil {
                    DispatchQueue.main.async {
                        let managerVC = ManagerViewController()
                        let navManager = UINavigationController(rootViewController: managerVC)
                        self.setUPVC(title: "Manager", image: "Paper", selectedImage: "PaperTapped", vc: managerVC)
                        UIView.transition(with: self.tabBar,
                                          duration: 0.4,
                                          options: .curveEaseIn,
                                          animations:{
                            self.viewControllers?.insert(navManager, at: 2)
                        }, completion: nil)
                    }
                   
                }
            } else{
                if let index = managerTab {
                    DispatchQueue.main.async {
                        UIView.transition(with: self.tabBar,
                                          duration: 0.4,
                                          options: .transitionFlipFromLeft,
                                          animations: {
                            self.viewControllers?.remove(at: index)
                        }, completion: nil)
                    }
                }
            }
        }
    }
    
    deinit {
        print(">> deinit from CustomTabBar")
    }
}
