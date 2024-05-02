//
//  StoreManagerDefaults.swift
//  OnlineStore
//
//  Created by Polina on 19.04.2024.
//

import Foundation
import FirebaseAuth

final class StoreManager{
    public enum Keys: String{
        case userRoleID
        case cart
        case saveSearches
        case wishList
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

    func saveUserRole(_ object: Any?, forKey key: Keys) {
        queueStore.async {
            guard let currentUserUId = Auth.auth().currentUser?.uid else { return }
            self.save(object: object, forKey: key.rawValue + currentUserUId)
            print("Save UserWithId Role")
        }
    }

    func saveCustomData<T>(object: T, forKey key: Keys) where T : Encodable {
        queueStore.async {
            if let jsonData = try? JSONEncoder().encode(object){
                guard let currentUserUId = Auth.auth().currentUser?.uid else { return }
                self.save(object: jsonData, forKey: key.rawValue + currentUserUId)
                print("Done Save")
            }
        }
    }
    
    func getUserRole(forKey key: Keys, completion: @escaping (String?) -> Void){
        queueStore.async {
            guard let currentUserUId = Auth.auth().currentUser?.uid else { return }
            let role = self.getSavedObject(forKey: key.rawValue + currentUserUId) as? String
            print("Get UserWithId Role")
            completion(role)
        }
    }
    
    func getCustomData<T: Decodable>(forKey key: Keys, completion: @escaping (T?) -> Void) {
        queueStore.async {
            guard let currentUserUId = Auth.auth().currentUser?.uid else { return }
            if let savedDataData = self.getSavedObject(forKey: key.rawValue + currentUserUId) as? Data{
                let decoder = JSONDecoder()
                if let savedData = try? decoder.decode(T.self, from: savedDataData){
                    completion(savedData)
                    print("Done Get")
                } else{
                    completion(nil)
                }
            }  else{
                completion(nil)
            }
        }
    }
    
    func remove(forKey key:  Keys){
        queueStore.async {
            self.userDefaults.removeObject(forKey: key.rawValue)
            print("remove for \(key.rawValue)")
        }
    }

}
