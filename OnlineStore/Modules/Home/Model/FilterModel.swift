//
//  FilterModel.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//

import Foundation
enum FilterModel: CaseIterable{
    case nameAlphabet, priceDescending, priceAscending, noFilter
}

extension FilterModel{
    var typeFilterLabel: String {
        switch self{
        case .nameAlphabet:
            return "Name Alphabet"
        case .priceDescending:
            return "Price Descending"
        case .noFilter:
            return "Switch Of Filter"
        case .priceAscending:
            return "Price Ascending"
        }
    }
}
