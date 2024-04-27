//
//  Label + ext.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//


import UIKit
enum CurrencyAppearency{
    case left
    case right
}

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
    
    func configPriceLabel(priceTitle: Int, type: CurrencyAppearency) {
        let currencySymbol: (usa: (String, String), russia: (String, String), europe: (String, String)) = type == .left ? (("$ ", ""), ("₽ ", ""), ("€ ", "")) : (("", " $"), ("", " ₽"), ("", " €"))
        
        if let currencyType = LocationManager.shared.currency {
            switch currencyType {
            case .usa:
                self.text = currencySymbol.usa.0 + String(priceTitle) + currencySymbol.usa.1
            case .russia:
                self.text = currencySymbol.russia.0 + String(priceTitle * 90) + currencySymbol.russia.1
            case .europe:
                self.text = currencySymbol.europe.0 + String(Int(Double(priceTitle) * 1.11)) + currencySymbol.europe.1
            }
        } else {
//            print("Default")
            self.text = currencySymbol.usa.0 + String(priceTitle) + currencySymbol.usa.1
        }
    }

}
