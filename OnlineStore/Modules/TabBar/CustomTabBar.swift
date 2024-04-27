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
        delegate = self
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
        setUPVC(title: "Home", image: UIImage(named: "Home"), vc: homeVC)
        setUPVC(title: "Wishlist", image: UIImage(named: "Heart"), vc: wishListVC)
        setUPVC(title: "Manager", image: UIImage(named: "Paper"), vc: managerVC)
        setUPVC(title: "Account", image: UIImage(named: "Profile"), vc: profileVC)
        self.setViewControllers([navHome, navWish, navManager, navProfile], animated: false)
    }
    
    private func setUPVC( title: String, image: UIImage?, vc: UIViewController){
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
    }
    
    private func setTabBarAppearence(){
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = UIColor(named: "CustomGreen")
        self.tabBar.unselectedItemTintColor = .gray

    }
    
    
    deinit {
        print(">> deinit from CustomTabBar")
    }
}
// MARK: - UITabBarControllerDelegate
extension CustomTabBar: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return }
        let tabBarItem = tabBar.items?[index]
        switch index{
        case 0:
            tabBarItem?.image = UIImage(named: "HomeTapped")
        case 1:
            tabBarItem?.image = UIImage(named: "HeartTapped")
        case 2:
            tabBarItem?.image = UIImage(named: "PaperTapped")
        case 3:
            tabBarItem?.image = UIImage(named: "ProfileTapped")
        default:
            break
        }
        
        if let previousSelectedIndex = previousSelectedIndex, previousSelectedIndex != index {
            let previousTabBarItem = tabBar.items?[previousSelectedIndex]
            switch previousSelectedIndex {
            case 0:
                previousTabBarItem?.image = UIImage(named: "Home")
            case 1:
                previousTabBarItem?.image = UIImage(named: "Heart")
            case 2:
                previousTabBarItem?.image = UIImage(named: "Paper")
            case 3:
                previousTabBarItem?.image = UIImage(named: "Profile")
            default:
                break
            }
        }

        self.previousSelectedIndex = index
    }
}
