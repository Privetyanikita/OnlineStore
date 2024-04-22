//
//  ResultSearchManager.swift
//  OnlineStore
//
//  Created by Polina on 22.04.2024.
//


import Foundation

final class SearchResultManager{
    static let shared = SearchResultManager()
    
    private init(){}
    
    private (set) var saveSearches: [SavesSerchesModel] = []
    
    func saveHistory(saveType: SaveSearchHistory, serchToSave: String, id: UUID?) -> [SavesSerchesModel]{
        let objectToSave = SavesSerchesModel(saveSearch: serchToSave)
        switch saveType{
        case .saveSearchWordResult:
            saveSearches.append(objectToSave)
            StoreManager.shared.saveCustomData(object: saveSearches,
                                               forKey: .saveSearches)
            return saveSearches
        case .deleteOne:
            if let index = saveSearches.firstIndex(where: { $0.id == id })
            {
                saveSearches.remove(at: index)
                StoreManager.shared.saveCustomData(object: saveSearches,
                                                   forKey: .saveSearches)
                return saveSearches
            }
            return saveSearches
        case .deleteAll:
            saveSearches = []
            StoreManager.shared.remove(forKey: .saveSearches)
            return saveSearches
        }
    }
    
    func saveHistorySearchWord(searchWord: String){
        StoreManager.shared.getCustomData(forKey: .saveSearches) { (savedSearches: [SavesSerchesModel]?) in
            if let savedSearches = savedSearches {
                self.saveSearches = savedSearches
                self.saveSearches.append(SavesSerchesModel(saveSearch: searchWord))
                StoreManager.shared.saveCustomData(object: self.saveSearches,
                                                   forKey: .saveSearches)
            } else {
                self.saveSearches.append(SavesSerchesModel(saveSearch: searchWord))
                StoreManager.shared.saveCustomData(object: self.saveSearches,
                                                   forKey: .saveSearches)
            }
        }
    }
}
