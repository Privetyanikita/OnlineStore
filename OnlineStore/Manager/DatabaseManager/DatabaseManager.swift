//
//  DatabaseManager.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 23.04.2024.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

enum DatabaseError: String, Error {
    case unableToFetchProducts = "Unable to get your products from database. Please try again"
    case failedToGetProduct = "Unable to get your product from database. Please try again"
}

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    
    private init() {}
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = emailAddress.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}


extension DatabaseManager {
    // MARK: - Product methods
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
                completion(.failure(DatabaseError.unableToFetchProducts))
                return
            }
            completion(.success(value))
        }
    }
    
    
    
    public func getProductByID(with uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
            let query: DatabaseQuery = database.child("products").queryOrdered(byChild: "product_id").queryEqual(toValue: uid)
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let key = (child as AnyObject).key as String
                    self.database.child("products").child(key).observeSingleEvent(of: .value, with: { snapshot in
                        guard let value = snapshot.value as? [String: Any] else {
                            completion(.failure(DatabaseError.failedToGetProduct))
                            return
                        }
                        completion(.success(value))
                    })
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    
    
    
    
}
