//
//  EndPoint.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 22.04.24.
//

import Foundation

enum EndPoint {
    //get
    case getProducts
    case getProductDetails(id: Int)
    case getCategories
    case getFilteredProducts(limit: Int?, offset: Int?, categoryId: Int?)
    case searchProductsByTitle(title: String)
    case getCurrency(country: String)
    //post
    case createProduct
    case createCategory
    case uploadImage
    //put
    case changeProduct(id: Int)
    case changeCategory(id: Int)
    //delete
    case deleteProduct(id: Int)
    case deleteCategory(id: Int)

    var path: String {
        switch self {
        case .getProducts, .getFilteredProducts, .searchProductsByTitle, .createProduct:
            return "/api/v1/products"
        case .getProductDetails(let id), .changeProduct(let id), .deleteProduct(let id):
            return "/api/v1/products/\(id)"
        case .getCategories:
            return "/api/v1/categories"
        case .createCategory:
            return "/api/v1/categories/"
        case .changeCategory(let id), .deleteCategory(let id):
            return "/api/v1/categories/\(id)"
        case .uploadImage:
            return "/api/v1/files/upload"
        case .getCurrency(let country):
            return "/v3.1/name/\(country)"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .getFilteredProducts(let limit, let offset, let categoryId):
            var items = [URLQueryItem]()
            if let limit = limit {
                items.append(URLQueryItem(name: "limit", value: String(limit)))
            }
            if let offset = offset {
                items.append(URLQueryItem(name: "offset", value: String(offset)))
            }
            if let categoryId = categoryId {
                items.append(URLQueryItem(name: "categoryId", value: String(categoryId)))
            }
            return items.isEmpty ? nil : items
        case .searchProductsByTitle(let title):
            return [URLQueryItem(name: "title", value: title)]
        default:
            return nil
        }
    }
}
