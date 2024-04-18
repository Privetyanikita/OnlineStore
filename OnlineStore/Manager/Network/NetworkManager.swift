//
//  NetworkManager.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 16.04.24.
//

import UIKit


//MARK: - URL Endpoints

enum Link {
    case products
    
    var url: URL {
        switch self {
        case .products:
            return URL(string: "https://api.escuelajs.co/api/v1/products")!
        }
    }
}


final class NetworkManager {
    
    //MARK: - Singleton
    
    static let shared = NetworkManager()
    private init() {}
    
    
    private func fetchProduct(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        
        let fetchRequest = URLRequest(url: Link.products.url)
        
        URLSession.shared.dataTask(with: fetchRequest) { (data, responce, error) -> Void in
            
            if error != nil {
                print("Error in session is not nil")
                completion(.failure(.noData))
            } else {
                //got data
                
                let httpResponce = responce as? HTTPURLResponse
                print("status code: \(httpResponce?.statusCode)")
                
                if httpResponce.statusCode == 429 {
                    completion(.failure(.tooManyRequests))
                } else {
                    guard let data else { return }
                    
                    do {
                        let decodedQuery = try JSONDecoder().decode(Query.self, from: data)
                        completion(.success([decodedQuery.products]))
                    } catch let decodedError {
                        print("Decoding error: \(decodedError.localizedDescription)")
                        completion(.failure(.decodingError))
                    }
                }
            }
        }.resume()
        
        print("try to fetch")
    }
}
