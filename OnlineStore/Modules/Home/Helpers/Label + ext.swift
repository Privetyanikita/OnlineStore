//
//  Label + ext.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//


import UIKit
extension UILabel {
    func configLabel(font: UIFont, lines: Int, alignment: NSTextAlignment, color: UIColor) {
        self.textAlignment = alignment
        self.textColor = color
        self.numberOfLines = lines
        self.font = font
        self.lineBreakMode = .byTruncatingTail
        self.sizeToFit()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configPriceLabel(priceTitle: Int){
        if let currencyType = LocationManager.shared.currency{
            switch currencyType{
            case .usa:
                self.text = String(priceTitle) + " $"
            case .russia:
                self.text = String(priceTitle * 90) + " ₽"
            case .europe:
                self.text = String(Int(Double(priceTitle) * 1.11)) + " €"
            }
        }
        else {
            print("Default")
            self.text = String(priceTitle) + " $"
        }
    }
}
