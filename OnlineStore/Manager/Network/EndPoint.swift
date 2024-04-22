//
//  EndPoint.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 22.04.24.
//

import Foundation

enum EndPoint {
    case getProducts
    case getCotigories
    case searchPodcasts
    case getEpisodsForPodcats
    
    var path: String {
        switch self {
        case .getProducts:
            return "/api/v1/products"
        case .getCotigories:
            return "/api/v1/categories"
        case .searchPodcasts:
            return "/api/v1/products/?title="
        case .getEpisodsForPodcats:
            return "/api/1.0/episodes/byfeedid"
        }
    }
}
