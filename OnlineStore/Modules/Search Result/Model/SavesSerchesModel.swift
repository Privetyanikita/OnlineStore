//
//  SearchModel.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import Foundation

struct SavesSerchesModel: Hashable, Codable{
    var id = UUID()
    let saveSearch: String
}

enum SaveSearchHistory{
    case saveSerchWordHome
    case saveSerchWordResult
    case deleteOne
    case deleteAll
}
