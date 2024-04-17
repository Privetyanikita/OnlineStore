//
//  CsrtTableViewCell.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 17.04.2024.
//

import UIKit

class CsrtTableViewCell: UITableViewCell {
    
    static let reudeID = "CartCell"
    
    private let checkbox: UISwitch = {
        let checkbox = UISwitch()
        checkbox.preferredStyle = .checkbox
        
        return checkbox
    }()
    
    private let photoImage: UIImageView = {
        let photoImage = UIImageView()
        photoImage.layer.cornerRadius = 6
        photoImage.contentMode = .scaleAspectFill
        
        return photoImage
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        
        return nameLabel
    }()
    
    func configureCell(with: Product) {
        
    }

}
