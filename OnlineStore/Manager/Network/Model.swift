//
//  Model.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 22.04.24.
//

import Foundation
import Firebase

struct Product: Codable, Hashable {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let images: [String]
    var isFavorite: Bool?
    
    public static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.title == rhs.title
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: Initialize with Raw Data
    init(id: Int, title: String, price: Int, description: String, images: [String], isFavorite: Bool? = false) {
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.images = images
        self.isFavorite = isFavorite
    }
    
    // MARK: Initialize with Firebase DataSnapshot
    init?(snapshot: DataSnapshot) {
      guard
        let value = snapshot.value as? [String: AnyObject],
        let title = value["product_title"] as? String,
        let price = value["product_price"] as? Int,
        let images = value["product_images"] as? [String],
        let id = value["product_id"] as? Int,
        let description = value["product_description"] as? String
      else {
        return nil
      }
      self.id = id
      self.title = title
      self.price = price
      self.images = images
      self.description = description
    }
}

struct ProductPost: Codable, Hashable {
    var title: String?
    var price: Int?
    var description: String?
    var categoryID: Int?
    var images: [String]?

    enum CodingKeys: String, CodingKey {
        case title, price, description
        case categoryID = "categoryId"
        case images
    }
}

struct Category: Codable, Hashable {
    let id: Int
    let name: String
    let image: String
}

struct CategoryPost: Codable, Hashable {
    var name: String?
    var image: String?
}

struct GeocodingResult: Decodable {
    let components: GeocodingComponents
}

struct GeocodingComponents: Decodable {
    let countryCode: String
}

struct Country: Decodable {
    let currencies: [String: Currency]
}

struct Currency: Decodable {
    let symbol: String
}

