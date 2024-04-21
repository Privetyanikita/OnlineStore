//
//  StoreManagerDefaults.swift
//  OnlineStore
//
//  Created by Polina on 19.04.2024.
//

import Foundation

final class StoreManager{
    public enum Keys: String{
        case onbording
        case cart
        case saveSearches
    }
    
    static let shared = StoreManager()
    
    private init(){}
    
    private let queueStore = DispatchQueue(label: "quee.Storemanager",qos: .userInteractive)
    
    private let userDefaults = UserDefaults.standard
    
    private func save(object: Any?, forKey key: String){
        userDefaults.setValue(object, forKey: key)
    }
    
    private func getSavedObject(forKey key: String) -> Any?{
        userDefaults.object(forKey: key)
    }

    func saveOnbording(_ object: Any?, forKey key: Keys) {
        queueStore.async {
            self.save(object: object, forKey: key.rawValue)
        }
    }

    func saveCustomData<T>(object: T, forKey key: Keys) where T : Encodable {
        queueStore.async {
            if let jsonData = try? JSONEncoder().encode(object){
                self.save(object: jsonData, forKey: key.rawValue
                )
                print("Done Save")
            }
        }
    }
    
    func getOnbording(forKey key: Keys, completion: @escaping (Bool?) -> Void){
        let status = getSavedObject(forKey: key.rawValue) as? Bool
        completion(status)
    }
    
    func getCustomData<T: Decodable>(forKey key: Keys, completion: @escaping (T) -> Void) {
        queueStore.async {
            if let savedDataData = self.getSavedObject(forKey: key.rawValue) as? Data{
                let decoder = JSONDecoder()
                if let savedData = try? decoder.decode(T.self, from: savedDataData){
                    completion(savedData)
                    print("Done Get")
                }
            }
        }
    }
    
    func remove(forKey key:  Keys){
        queueStore.async {
            self.userDefaults.removeObject(forKey: key.rawValue)
        }
    }
}
