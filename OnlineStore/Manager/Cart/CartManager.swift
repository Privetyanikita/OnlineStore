//
//  CartManager.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 20.04.2024.
//

import Foundation

class CartManager {
    
    static let shared = CartManager()
    
    private (set) var currentProducts = [CartProduct]()
    
    func addProductToCart(_ product: ProductsModel) {
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
}
