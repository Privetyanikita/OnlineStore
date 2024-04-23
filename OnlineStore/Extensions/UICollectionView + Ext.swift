//
//  UICollectionView + ext.swift
//  OnlineStore
//
//  Created by Polina on 22.04.2024.
//
import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell of type \(T.self)")
        }
        return cell
    }
    
    func registerHeader<T: UICollectionReusableView>(supplementaryViewType: T.Type) {
        register(supplementaryViewType.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.headerIdentifier)
    }
    
    func reuseSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, type: T.Type, for indexPath: IndexPath) -> T {
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.headerIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a supplementary view of type \(T.self)")
        }
        return supplementaryView
    }
}
