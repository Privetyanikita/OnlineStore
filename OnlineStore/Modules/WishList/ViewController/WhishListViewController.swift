//
//  WhishListViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

class WhishListViewController: BaseViewController {
    
    private let wishView = WishView()
    
    private var products: [Product] = [ // подгрузить из БД во ViewWillAppear
        .init(id: 1, title: "Hello", price: 100, description: "Hello,Hello", images: ["https://i.imgur.com/ZANVnHE.jpeg"]),
        .init(id: 2, title: "sfsdsd", price: 200, description: "fsdfsdmn", images: ["https://i.imgur.com/ZANVnHE.jpeg"]),
        .init(id: 3, title: "sdklfafkas", price: 300, description: "fsdfsdmnsfdjsdf", images: ["https://i.imgur.com/ZANVnHE.jpeg"]),
        .init(id: 4, title: "AAAA", price: 400, description: "fsdfsdmnsfdjsdf", images: ["https://i.imgur.com/ZANVnHE.jpeg"]),
        .init(id: 5, title: "BBB", price: 500, description: "fsdfsdmnsfdjsdf", images: ["https://i.imgur.com/ZANVnHE.jpeg"]),
    ]
    private var filterProducts: [Product] = .init()
    private var filter: Bool = false
    
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
        wishView.applySnapShotWishList(products: products)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //сохранить в бд массив products
    }
}

// MARK: - SetUP NavBar
private extension WhishListViewController{
    func hookUpNavBar() {
        customNavigationBar.searchTextField.delegate = self
        customNavigationBar.shoppingCartButton.addTarget(self, action: #selector(shoppingCartButtonTapped), for: .touchUpInside)
    }
    
    @objc func shoppingCartButtonTapped() {
        print(">> SHOPPING CART BTN tapped")
    }
}

// MARK: - UICollectionViewDelegate
extension WhishListViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = wishView.getItemWishList(index: indexPath) else { return }
        router.push(DetailViewController(product: item),animated: true) // переход на детальный экран
    }
}

// MARK: - UISearchBarDelegate
extension WhishListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else {return}
        filter = text.isEmpty ? false : true
        filterProducts = filter ? products.filter { $0.title.contains(text) } : products
        wishView.applySnapShotWishList(products: filterProducts)
    }
}

// MARK: - SearchViewDelegateProtocol
extension WhishListViewController: WishViewDelegateProtocol{
    func addToCart(item: Product) {
        print("add to cart \(item)")
    }
    
    func deleteFromWishList(item: Product) {
        if filter{
            filterProducts = filterProducts.filter{ $0.id != item.id }
            products = products.filter{ $0.id != item.id } // чтобы удаление при поиске применилось к основному массиву
            wishView.applySnapShotWishList(products: filterProducts) //чтобы увидеть удаление еще при поиске
        } else { // если удаляем вне поиска
            products = products.filter{ $0.id != item.id }
            wishView.applySnapShotWishList(products: products)
        }
    }
}
