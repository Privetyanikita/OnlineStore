//
//  ResultSearchManager.swift
//  OnlineStore
//
//  Created by Polina on 22.04.2024.
//


import Foundation

protocol SearchResultManagerProtocol: AnyObject {
    func updateSaveSearches(saveSearches: [SavesSerchesModel] )
}

final class SearchResultManager{
    static let shared = SearchResultManager()
    weak var delegate: SearchResultManagerProtocol?
    
    private init(){}
    
    private var saveSearches: [SavesSerchesModel] = []
    
    func saveHistory(saveType: SaveSearchHistory, serchToSave: String, id: UUID?){
        let objectToSave = SavesSerchesModel(saveSearch: serchToSave)
        switch saveType{
        case .saveSearchWordResult:
            saveSearches.append(objectToSave)
            self.delegate?.updateSaveSearches(saveSearches: saveSearches)
            StoreManager.shared.saveCustomData(object: saveSearches,
                                               forKey: .saveSearches)
        case .deleteOne:
            if let index = saveSearches.firstIndex(where: { $0.id == id })
            {
                saveSearches.remove(at: index)
                self.delegate?.updateSaveSearches(saveSearches: saveSearches)
                StoreManager.shared.saveCustomData(object: saveSearches,
                                                   forKey: .saveSearches)
            }
        case .deleteAll:
            saveSearches = []
            self.delegate?.updateSaveSearches(saveSearches: saveSearches)
            StoreManager.shared.remove(forKey: .saveSearches)
        }
    }
    
    func saveHistorySearchWord(searchWord: String){
        StoreManager.shared.getCustomData(forKey: .saveSearches) { [ weak self ] (savedSearches: [SavesSerchesModel]?) in
            guard let self else { return }
            if let savedSearches = savedSearches {
                self.saveSearches = savedSearches
                self.saveSearches.append(SavesSerchesModel(saveSearch: searchWord))
                self.delegate?.updateSaveSearches(saveSearches: self.saveSearches)
                StoreManager.shared.saveCustomData(object: self.saveSearches,
                                                   forKey: .saveSearches)
            } else {
                self.saveSearches.append(SavesSerchesModel(saveSearch: searchWord))
                self.delegate?.updateSaveSearches(saveSearches: self.saveSearches)
                StoreManager.shared.saveCustomData(object: self.saveSearches,
                                                   forKey: .saveSearches)
            }
        }
    }
}
