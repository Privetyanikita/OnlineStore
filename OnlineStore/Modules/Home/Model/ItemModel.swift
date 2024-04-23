//
//  ItemModel.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//


import Foundation
enum ItemModel: Hashable{
    case searchBar
    case categories(Category)
    case products(Product)
}

struct CategoriesModel: Hashable{
    let id: Int
    let name: String
    let image: String
}

struct ProductsModel: Hashable{
    let id: Int
    let image: String
    let description: String
    let price: Int
    var isLiked: Bool
}

enum Titles{
    static let title = "Delivery Address"
    static let subTitle = "Salatiga City, Central Java"
}
