//
//  NetworkError.swift
//  OnlineStore
//
//  Created by Evgenii Mazrukho on 18.04.2024.
//

import Foundation

enum NetworkError: Error {
    case noData
    case tooManyRequests
    case decodingError
}
