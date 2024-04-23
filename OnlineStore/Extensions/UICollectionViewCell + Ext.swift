//
//  UICollectionViewCell + Ext.swift
//  OnlineStore
//
//  Created by Polina on 22.04.2024.
//

import UIKit

extension UICollectionViewCell{
    static var reuseIdentifier: String {
        String(describing: self)
    }

    open override var reuseIdentifier: String {
        type(of: self).reuseIdentifier
    }
}

