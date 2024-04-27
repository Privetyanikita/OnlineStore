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

