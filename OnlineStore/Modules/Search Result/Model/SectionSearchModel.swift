//
//  SectionSearchModel.swift
//  OnlineStore
//
//  Created by Polina on 18.04.2024.
//

import Foundation

enum SectionSearchModel: Int, CaseIterable, Hashable{
    case searchResult
}

extension SectionSearchModel{
    var title: String{
        switch self{
        case .searchResult:
            return "Search result for "
        }
    }
}
