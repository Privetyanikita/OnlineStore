//
//  WishListManager.swift
//  OnlineStore
//
//  Created by Polina on 27.04.2024.
//

import Foundation

protocol WishListManagerProtocol: AnyObject {
    func updateProducts(products: [Product] )
}

final class WishListManager{
    static let shared = WishListManager()
    weak var delegate: WishListManagerProtocol?
    
    private init(){}
    
    private var products: [Product] = []
    private var filterProducts: [Product] = .init()
    private var filter: Bool = false
    
    func saveProduct(item: Product){ // сохраняем в DetailVC
        products.append(item)
        StoreManager.shared.saveCustomData(object: products, forKey: .wishList)
    }
    
    func deleteProduct(item: Product){ // удаляем в DetailVC
        let newPducts = products.filter { $0.id != item.id }
        StoreManager.shared.saveCustomData(object: newPducts, forKey: .wishList)
    }
    
    func deleteOneProductFromWishList(item: Product){ // из WishListVC
        if filter{
            filterProducts = filterProducts.filter{ $0.id != item.id }
            products = products.filter{ $0.id != item.id } // чтобы удаление при поиске применилось к основному массиву
            delegate?.updateProducts(products: filterProducts) //чтобы увидеть удаление еще при поиске
        } else { // если удаляем вне поиска
            products = products.filter{ $0.id != item.id }
            delegate?.updateProducts(products: products)
        }
    }
    
    func saveProducts(){ // вызываем во viewWillDisspear WishListVC
        StoreManager.shared.saveCustomData(object: products, forKey: .wishList) // сохраняем в бд
    }
    
    func filterProductsInWishLIst(text: String){ // поиск по WishList в WishListVC
        filter = text.isEmpty ? false : true
        filterProducts = filter ? products.filter { $0.title.contains(text) } : products
        delegate?.updateProducts(products: filterProducts)
    }
    
    func getWishList(){ // вызываем во viewDidLoad HomeVC и во viewWillAppear WishListVC
        StoreManager.shared.getCustomData(forKey: .wishList) { [ weak self ] (productsData: [Product]?) in
            guard let self else { return }
            if let productsData{
                self.products = productsData
                self.delegate?.updateProducts(products: self.products)
            } else {
                self.products = []
                self.delegate?.updateProducts(products: self.products)
            }
        }
    }
}

