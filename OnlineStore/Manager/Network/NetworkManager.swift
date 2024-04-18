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
    
    var products = [Product]()
    
    
    
    func fetchProduct() {
        
        let fetchRequest = URLRequest(url: Link.products.url)
        
        URLSession.shared.dataTask(with: fetchRequest) { [weak self] (data, responce, error) -> Void in
            
            if error != nil {
                print("Error in session is not nil")
            } else {
                //got data
                
                let httpResponce = responce as? HTTPURLResponse
                
                print("status code: \(httpResponce?.statusCode)")
            }
            
            guard let data else { return }
                
            if let decodedQuery = try? JSONDecoder().decode(Query.self, from: data) {
                
                DispatchQueue.main.async {
                    self?.products = decodedQuery?.Root
                }
            }
            
            
            
        }.resume()
        
        print("try to fetch")
        
        
    }
}
