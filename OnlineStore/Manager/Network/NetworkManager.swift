//
//  NetworkManager.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 16.04.24.
//

import Foundation

enum NetworkError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
}

struct NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        let url = createURL(for: .getProducts, hostType: .productHost)
        performRequest(with: url, completion: completion)
    }
    
    func fetchCategories(completion: @escaping (Result<[Category], NetworkError>) -> Void) {
        let url = createURL(for: .getCategories, hostType: .productHost)
        performRequest(with: url, completion: completion)
    }
    
    func fetchFilteredProducts(limit: Int? = nil, offset: Int? = nil, categoryId: Int? = nil, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        let endPoint = EndPoint.getFilteredProducts(limit: limit, offset: offset, categoryId: categoryId)
        let url = createURL(for: endPoint, hostType: .productHost)
        performRequest(with: url, completion: completion)
    }
    
    func fetchProductDetails(id: Int, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        let endPoint = EndPoint.getProductDetails(id: id)
        let url = createURL(for: endPoint, hostType: .productHost)
        performRequest(with: url, completion: completion)
    }
    
    func searchProductsByTitle(title: String, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        let endPoint = EndPoint.searchProductsByTitle(title: title)
        let url = createURL(for: endPoint, hostType: .productHost)
        performRequest(with: url, completion: completion)
    }
    
    func fetchCountryCurrency(country: String, completion: @escaping (Result<[Country], NetworkError> ) -> Void){
        let endPoint = EndPoint.getCurrency(country: country)
        let url = createURL(for: endPoint, hostType: .countryHost)
        performRequest(with: url, completion: completion)
    }
    
    private func performRequest<T: Decodable>(with url: URL?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = url else {
            completion(.failure(.noData))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data else {
                completion(.failure(.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)))
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    private func createURL(for endPoint: EndPoint, hostType: HostType) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        switch hostType{
        case .productHost:
            components.host = API.host
        case .countryHost:
            components.host = API.hostCountry
        }
        components.path = endPoint.path
        components.queryItems = endPoint.queryItems
        return components.url
    }
}
