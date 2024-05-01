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
        setTabBarAppearence()
        generateTabBar()
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
    
    deinit {
        print(">> deinit from CustomTabBar")
    }
}
