//
//  UIView + Ext.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 16.04.2024.
//

import UIKit

extension UIView {
    
    func setCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    
    func circleCorner() {
        superview?.layoutIfNeeded()
        setCorner(radius: frame.height / 2)
    }
}
