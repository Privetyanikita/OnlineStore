//
//  CartManager.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 20.04.2024.
//

import Foundation

protocol CartManagerDelegate: AnyObject {
    func getProductsCount(count: Int)
}

class CartManager {
    
    static let shared = CartManager()
    
    weak var delegate: CartManagerDelegate? {
        didSet {
            delegate?.getProductsCount(count: currentProducts.count)
        }
    }
    
    private (set) var currentProducts = [CartProduct]() {
        didSet {
            delegate?.getProductsCount(count: currentProducts.count)
            StoreManager.shared.saveCustomData(object: currentProducts, forKey: .cart)
        }
    }
    
    func addProductToCart(_ product: Product) {
        let existingProducts = currentProducts.map { $0.product }
        if let index = existingProducts.firstIndex(of: product) {
            currentProducts[index].count += 1
        } else {
            currentProducts.append(CartProduct(product: product))
        }
    }
    
    func removeProductFromCart(_ product: CartProduct) {
        if let index = currentProducts.firstIndex(of: product) {
            currentProducts.remove(at: index)
        }
    }
    
    func changeProductCheckeredState(_ product: CartProduct) {
        if let index = currentProducts.firstIndex(of: product) {
            currentProducts[index].isChecked.toggle()
        }
    }
    
    func changeProductCount(_ product: CartProduct, value: Int) {
        if let index = currentProducts.firstIndex(of: product) {
            currentProducts[index].count += value
        }
    }
    
    func didPay() {
        for cartProduct in currentProducts {
            if cartProduct.isChecked {
                if let index = currentProducts.firstIndex(of: cartProduct) {
                    currentProducts.remove(at: index)
                }
            }
        }
    }
    
    func calculateTotalSum() -> Int {
        var totalSum = 0
        for cartProduct in currentProducts {
            if cartProduct.isChecked {
                totalSum += cartProduct.product.price * cartProduct.count
            }
        }
        return totalSum
    }
    
    func setup() {
        StoreManager.shared.getCustomData(forKey: .cart) { (products: [CartProduct]?) in
            if let products {
                DispatchQueue.main.sync {
                    self.currentProducts = products
                }
            } else {
                DispatchQueue.main.sync {
                    self.currentProducts = [CartProduct]()
                }
            }
        }
    }
}
