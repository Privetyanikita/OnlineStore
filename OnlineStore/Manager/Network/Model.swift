//
//  Model.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 22.04.24.
//

import Foundation

struct Product: Codable, Hashable {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let images: [String]
    
    //TODO: create func instead of computed property
    
   static func getBookmarkedProducts(completion: @escaping ([Product]) -> Void) {
        var bookmarkedProducts: [Product] = []
        DatabaseManager.shared.getAllProducts { result in
            switch result {
            case .success(let products):

                for (_, productData) in products {
                    guard let value = productData as? [String: Any] else { return }
                    if let title = value["product_title"] as? String,
                       let price = value["product_price"] as? Int,
                       let images = value["product_images"] as? [String],
                       let description = value["product_description"] as? String,
                       let id = value["product_id"] as? Int {
                       let product = Product(id: id, title: title, price: price, description: description, images: images)
                       bookmarkedProducts.append(product)
                    }
                }
                completion(bookmarkedProducts)
            case .failure(let failure):
                break
            }
        }
    }
    
    var isBookmarked = false
}


struct Category: Codable, Hashable {
    let id: Int
    let name: String
    let image: String
}

