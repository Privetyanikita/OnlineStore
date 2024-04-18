//
//  SectionsSavesModel.swift
//  OnlineStore
//
//  Created by Polina on 18.04.2024.
//

import Foundation


enum SectionsSavesModel: Int, CaseIterable, Hashable{
    case savesSerches
}

extension SectionsSavesModel{
    var title: String{
        switch self{
        case .savesSerches:
            return "Last Search"
        }
    }
}
