//
//  Product.swift
//  OnlineStore
//
//  Created by Evgenii Mazrukho on 18.04.2024.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let images: [String]
}


struct Query: Decodable {
    let Root: [Product]
}
