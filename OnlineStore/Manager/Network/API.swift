//
//  API.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 22.04.24.
//

import Foundation

enum HostType: String{
    case productHost
    case countryHost
}

struct API{
    static let scheme = "https"
    static let host = "api.escuelajs.co"
    static let hostCountry = "restcountries.com"
}
