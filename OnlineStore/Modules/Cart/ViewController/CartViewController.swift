//
//  CartViewModel.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

class CartViewController: BaseViewController, CartProductTableViewCellDelegate {
    
    private let cartView = CartView()
    
    private var cartProducts: [CartProduct] = CartManager.shared.currentProducts
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hookUpNavBarButtons()
    }

    override func loadView() {
        super.loadView()
        cartView.cellToRegister = { CartProductTableViewCell.self }
        cartView.tableViewHandler = self
        cartView.totalSum = CartManager.shared.calculateTotalSum()
        cartView.configureTableView()
        cartView.onPayTap = goToPayment
        view = cartView
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
    
    func productCountChanged(_ product: CartProduct, value: Int) {
        CartManager.shared.changeProductCount(product, value: value)
        updateProducts()
    }
    
    func deleteProductFromCart(_ product: CartProduct) {
        CartManager.shared.removeProductFromCart(product)
        updateProducts()
    }
    
    func productCheckedStateChanded(_ product: CartProduct) {
        CartManager.shared.changeProductCheckeredState(product)
        updateProducts()
    }
    
    private func updateProducts() {
        cartProducts = CartManager.shared.currentProducts
        cartView.totalSum = CartManager.shared.calculateTotalSum()
        view.layoutIfNeeded()
    }
    
    private func goToPayment() {
        let paymentVC = PaymentViewController()
        paymentVC.modalPresentationStyle = .fullScreen
        present(paymentVC, animated: true)
        CartManager.shared.didPay()
        updateProducts()
    }
    
    @objc private func backButtonTapped() {
        print(">> BACK BTN tapped")
        dismiss(animated: true)
    }
    
    @objc private func shoppingCartButtonTapped() {
        print(">> SHOPPING CART BTN tapped")
    }
    
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartProductCell", for: indexPath) as? CartProductTableViewCell else { return UITableViewCell() }
        cell.configureCell(with: cartProducts[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}
