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

struct Category: Codable, Hashable {
    let id: Int
    let name: String
    let image: String
}

