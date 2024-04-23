//
//  DatabaseManager.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 23.04.2024.
//

import Foundation
import FirebaseDatabase

enum DatabaseError: String, Error {
    case unableToFetch   = "Unable to get your products from database. Please try again"
}

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    
    private init() {}
}


extension DatabaseManager {
    
    public func insertProduct(with product: Product, completion: @escaping (Bool) -> Void) {
        let productDetail: [String: Any] = [
            "product_id": product.id,
            "product_title": product.title,
            "product_price": product.price,
            "product_description": product.description,
            "product_images": product.images
        ]
        database.child("products").setValue(productDetail) { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    public func getAllProducts(completion: @escaping (Result<[[String: Any]], DatabaseError>) -> Void) {
        database.child("products").observeSingleEvent(of: .value) { snapshot, _  in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.unableToFetch))
                return
            }
            completion(.success(value))
        }
    }
}
