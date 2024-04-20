//
//  SectionModel.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//

import Foundation
enum SectionModel: CaseIterable, Hashable {
    case searchbar
    case categories
    case products
    
    var title: String{
        switch self{
        case .categories:
            return ""
        case .products:
            return "Products"
        case .searchbar:
            return ""
        }
    }
}
