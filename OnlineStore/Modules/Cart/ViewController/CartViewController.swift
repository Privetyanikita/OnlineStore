//
//  CartViewModel.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

class CartViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hookUpNavBarButtons()
    }

    override func loadView() {
        super.loadView()
        view = CartView()
    }
    
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
       CustomNavigationBarConfiguration(
        title: Text.cart,
        withSearchTextField: false,
        isSetupBackButton: true,
        rightButtons: [.shoppingCart])
    }
    
    private func hookUpNavBarButtons() {
        customNavigationBar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        customNavigationBar.shoppingCartButton.addTarget(self, action: #selector(shoppingCartButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        print(">> BACK BTN tapped")
    }
    
    @objc private func shoppingCartButtonTapped() {
        print(">> SHOPPING CART BTN tapped")
    }
    
}
