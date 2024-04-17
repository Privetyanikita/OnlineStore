//
//  UIImage + Ext.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 16.04.2024.
//

import UIKit

extension UIImage {
    
    static func imageWithColor(color: UIColor, size: CGSize) -> UIImage? {
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            color.setFill()
            UIRectFill(rect)
            guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
                return nil
            }
            UIGraphicsEndImageContext()
            return image
        }
}
