//
//  CustomTextField.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 21.04.2024.
//

import UIKit


class CustomTextField: UITextField {
    
    struct Constants {
        static let sidePadding: CGFloat = 15
        static let topPadding: CGFloat = 0
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleCorner()
    }
    

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + Constants.sidePadding, y: bounds.origin.y + Constants.topPadding, width: bounds.size.width - Constants.sidePadding * 2, height: bounds.size.height - Constants.topPadding * 2)
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
            var rect = super.rightViewRect(forBounds: bounds)
            rect.origin.x -= 15 
            return rect
          }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
            var rect = super.clearButtonRect(forBounds: bounds)
            rect.origin.x -= 15
            return rect
        }
    
}
