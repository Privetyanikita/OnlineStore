//
//  DetailViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

class DetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavBarItems()
    }

    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
       CustomNavigationBarConfiguration(
        title: Text.detailsProduct,
        withSearchTextField: false,
        isSetupBackButton: true,
        rightButtons: [.shoppingCart])
    }
    
    
    private func setupNavBarItems() {
        customNavigationBar.searchTextField.delegate = self
        hookUpNavBarButtons()
    }
    
    
    private func hookUpNavBarButtons() {
        customNavigationBar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        customNavigationBar.notificationButton.addTarget(self, action: #selector(notificationsButtonTapped), for: .touchUpInside)
        customNavigationBar.shoppingCartButton.addTarget(self, action: #selector(shoppingCartButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        print(">> BACK BTN tapped")
    }
    
    @objc private func notificationsButtonTapped() {
        print(">> NOTIFICATIONS BTN tapped")
    }
    
    @objc private func shoppingCartButtonTapped() {
        print(">> SHOPPING CART BTN tapped")
    }
}


extension DetailViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("searchText \(searchText)")
        }
}
