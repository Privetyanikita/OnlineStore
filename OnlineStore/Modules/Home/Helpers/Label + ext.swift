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
}
