//
//  UIButton + Ext.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 16.04.2024.
//

import UIKit

extension UIButton {
    func animate(deep: Animate) {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = self.transform.scaledBy(x: deep.value, y: deep.value)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}

enum Animate {
    case small
    case medium
    case large

    var value: CGFloat {
        switch self {
        case .small:
            return 0.97
        case .medium:
            return 0.85
        case .large:
            return 0.75
        }
    }
}
