//
//  NetworkManager.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 16.04.24.
//

import Foundation
import CryptoKit

enum NetworkError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
}

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private func 
}
