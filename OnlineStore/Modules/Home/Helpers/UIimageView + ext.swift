//
//  UIimageView + ext.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//

import UIKit
extension UIImageView {
    func configImageView(cornerRadius: CGFloat, contentMode: UIView.ContentMode){
        self.layer.cornerRadius = cornerRadius
        self.contentMode = contentMode
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
