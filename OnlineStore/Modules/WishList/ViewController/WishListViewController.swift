//
//  WhishListViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

class WishListViewController: BaseViewController {
    
    private let wishView = WishView()
    
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
        CustomNavigationBarConfiguration(
            title: "",
            withSearchTextField: true,
            isSetupBackButton: false,
            rightButtons: [.shoppingCart])
    }
    
    override func loadView() {
        super.loadView()
        wishView.setUPDelegates(delegeteWishList: self,
                                delegate: self)
        view = wishView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hookUpNavBar()
        customNavigationBar.searchTextField.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        WishListManager.shared.delegate = self
        WishListManager.shared.getWishList()  // подгружаем WishList
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        WishListManager.shared.saveProducts()
    }
}

// MARK: - SetUP NavBar
private extension WishListViewController{
    func hookUpNavBar() {
        customNavigationBar.searchTextField.delegate = self
        customNavigationBar.shoppingCartButton.addTarget(self, action: #selector(shoppingCartButtonTapped), for: .touchUpInside)
    }
    
    @objc func shoppingCartButtonTapped() {
        print(">> SHOPPING CART BTN tapped")
        router.push(CartViewController(), animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension WishListViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = wishView.getItemWishList(index: indexPath) else { return }
        router.push(DetailViewController(product: item),animated: true) // переход на детальный экран
    }
}

// MARK: - UISearchBarDelegate
extension WishListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else {return}
        WishListManager.shared.filterProductsInWishLIst(text: text)
    }
}

// MARK: - SearchViewDelegateProtocol
extension WishListViewController: WishViewDelegateProtocol{
    func addToCart(item: Product) {
        print("add to cart \(item)")
        CartManager.shared.addProductToCart(item)
    }
    
    func deleteFromWishList(item: Product) {
        WishListManager.shared.deleteOneProductFromWishList(item: item)
    }
}

extension WishListViewController: WishListManagerProtocol{
    func updateProducts(products: [Product]) {
        wishView.applySnapShotWishList(products: products)
    }
}
