//
//  NetworkManager.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 16.04.24.
//

import Foundation
import UIKit

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
        guard let url = createURL(for: .getProducts, hostType: .productHost) else {
            completion(.failure(.noData))
            return
        }
        let request = URLRequest(url: url)
        performRequest(with: request, completion: completion)
    }
    
    func fetchCategories(completion: @escaping (Result<[Category], NetworkError>) -> Void) {
        guard let url = createURL(for: .getCategories, hostType: .productHost) else {
            completion(.failure(.noData))
            return
        }
        let request = URLRequest(url: url)
        performRequest(with: request, completion: completion)
    }
    
    func fetchFilteredProducts(limit: Int? = nil, offset: Int? = nil, categoryId: Int? = nil, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        let endPoint = EndPoint.getFilteredProducts(limit: limit, offset: offset, categoryId: categoryId)
        guard let url = createURL(for: endPoint, hostType: .productHost) else {
            completion(.failure(.noData))
            return
        }
        let request = URLRequest(url: url)
        performRequest(with: request, completion: completion)
    }
    
    func fetchProductDetails(id: Int, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        let endPoint = EndPoint.getProductDetails(id: id)
        guard let url = createURL(for: endPoint, hostType: .productHost) else {
            completion(.failure(.noData))
            return
        }
        let request = URLRequest(url: url)
        performRequest(with: request, completion: completion)
    }
    
    func searchProductsByTitle(title: String, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        let endPoint = EndPoint.searchProductsByTitle(title: title)
        guard let url = createURL(for: endPoint, hostType: .productHost) else {
            completion(.failure(.noData))
            return
        }
        let request = URLRequest(url: url)
        performRequest(with: request, completion: completion)
    }
    
    func searchCategoriesByTitle(title: String, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        let endPoint = EndPoint.searchCategoriesByTitle(title: title)
        guard let url = createURL(for: endPoint, hostType: .productHost) else {
            completion(.failure(.noData))
            return
        }
        let request = URLRequest(url: url)
        performRequest(with: request, completion: completion)
    }
    
    func fetchCountryCurrency(country: String, completion: @escaping (Result<[Country], NetworkError>) -> Void){
        let endPoint = EndPoint.getCurrency(country: country)
        guard let url = createURL(for: endPoint, hostType: .countryHost) else {
            completion(.failure(.noData))
            return
        }
        let request = URLRequest(url: url)
        performRequest(with: request, completion: completion)
    }
    
    func createProduct(product: ProductPost, completion: @escaping (Result<ProductPost, NetworkError>) -> Void) {
        let endPoint = EndPoint.createProduct
        guard let url = createURL(for: endPoint, hostType: .productHost) else {
            completion(.failure(.noData))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(product)
        } 
        catch {
            completion(.failure(.decodingError(error)))
            return
        }
        
        performRequest(with: request, completion: completion)
    }
    
    func changeProduct(id: Int, product: ProductPost, completion: @escaping (Result<ProductPost, NetworkError>) -> Void) {
        let endPoint = EndPoint.changeProduct(id: id)
        guard let url = createURL(for: endPoint, hostType: .productHost) else {
            completion(.failure(.noData))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(product)
        } 
        catch {
            completion(.failure(.decodingError(error)))
            return
        }
        
        performRequest(with: request, completion: completion)
    }
    
    func deleteProduct(id: Int, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let endPoint = EndPoint.deleteProduct(id: id)
        guard let url = createURL(for: endPoint, hostType: .productHost) else {
            completion(.failure(.noData))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        performRequest(with: request, completion: completion)
    }
    
    func createCategory(category: CategoryPost, completion: @escaping (Result<CategoryPost, NetworkError>) -> Void) {
        let endPoint = EndPoint.createCategory
        guard let url = createURL(for: endPoint, hostType: .productHost) else {
            completion(.failure(.noData))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(category)
        }
        catch {
            completion(.failure(.decodingError(error)))
            return
        }
        
        performRequest(with: request, completion: completion)
    }
    
    func changeCategory(id: Int, category: CategoryPost, completion: @escaping (Result<CategoryPost, NetworkError>) -> Void) {
        let endPoint = EndPoint.changeCategory(id: id)
        guard let url = createURL(for: endPoint, hostType: .productHost) else {
            completion(.failure(.noData))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(category)
        }
        catch {
            completion(.failure(.decodingError(error)))
            return
        }
        
        performRequest(with: request, completion: completion)
    }
    
    func deleteCategory(id: Int, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let endPoint = EndPoint.deleteCategory(id: id)
        guard let url = createURL(for: endPoint, hostType: .productHost) else {
            completion(.failure(.noData))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        performRequest(with: request, completion: completion)
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(.failure(.noData))
            return
        }
        
        guard let url = createURL(for: EndPoint.uploadImage, hostType: .productHost) else{
            completion(.failure(.noData))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(parameters: nil, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.transportError(error!)))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let responseString = String(data: data, encoding: .utf8) ?? ""
                completion(.success(responseString))
            } 
            else {
                completion(.failure(.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)))
            }
        }.resume()
    }
    
    private func createBodyWithParameters(parameters: [String: String]?, filePathKey: String, imageDataKey: Data, boundary: String) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append("\(boundaryPrefix)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        body.append("\(boundaryPrefix)")
        body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageDataKey)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    func performRequest<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 || httpResponse.statusCode == 201,
                  let data = data else {
                completion(.failure(.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)))
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch let decodingError as DecodingError {
                completion(.failure(.decodingError(decodingError)))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    private func createURL(for endPoint: EndPoint, hostType: HostType) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        switch hostType {
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

//MARK: - Helper
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
