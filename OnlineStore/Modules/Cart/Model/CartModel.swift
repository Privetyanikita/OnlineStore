//
//  CartModel.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

struct CartProduct: Equatable, Codable {
    let product: Product
    var count = 1
    var isChecked: Bool = true
}
