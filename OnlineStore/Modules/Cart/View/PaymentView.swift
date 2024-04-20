//
//  PaymentView.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 20.04.2024.
//

import UIKit

class PaymentView: UIView {
    
    private let cardLabel: UILabel = {
        let cardLabel = UILabel()
        cardLabel.font = Font.getFont(.semiBold, size: 16)
        cardLabel.textColor = .label
        cardLabel.textAlignment = .left
        cardLabel.text = "Select existing card"
        
        return cardLabel
    }()
    
    private let cardField: UITextField = {
        let cardField = UITextField(title: "**** **** **** 3961", leftPicName: "creditcard", rightPicName: "trash")
        
        return cardField
    }()
    
    private let separator: UIView = {
        let separator = UIView(frame: CGRect(origin: .zero, size: .init(width: .zero, height: 2)))
        separator.backgroundColor = .customLightGrey
        
        return separator
    }()
    
    private let newCardLabel: UILabel = {
        let newCardLabel = UILabel()
        newCardLabel.font = Font.getFont(.semiBold, size: 16)
        newCardLabel.textColor = .label
        newCardLabel.textAlignment = .left
        newCardLabel.text = "Or input new card"
        
        return newCardLabel
    }()
    
    private let newCardField: UITextField = {
        let cardField = UITextField(title: "", leftPicName: "creditcard", rightPicName: nil)
        
        return cardField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        let stack = UIStackView(arrangedSubviews: [cardLabel, cardField, separator, newCardLabel, newCardField])
        stack.axis = .vertical
        stack.spacing = 20
        addSubview(stack)
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(64)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
}

extension UITextField {
    convenience init(title: String, leftPicName: String?, rightPicName: String?) {
        self.init(frame: .zero)
        setupUIForCard(title: title, leftPicName: leftPicName, rightPicName: rightPicName)
        isEnabled = false
    }
    
    private func setupUIForCard(title: String, leftPicName: String?, rightPicName: String?) {
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        font = Font.getFont(.medium, size: 14)
        textColor = .darkGray
        textAlignment = .left
        text = title
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        if let leftPicName {
            let leftContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let cardImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
            cardImage.image = UIImage(systemName: leftPicName)
            cardImage.contentMode = .scaleAspectFit
            leftContainer.addSubview(cardImage)
            
            leftView = leftContainer
            leftViewMode = .always
            leftView?.tintColor = .gray
        }
        
        if let rightPicName {
            let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let deleteImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
            deleteImage.image = UIImage(systemName: rightPicName)
            deleteImage.contentMode = .scaleAspectFit
            rightContainer.addSubview(deleteImage)
            
            rightView = rightContainer
            rightViewMode = .always
            rightView?.tintColor = .gray
        }
        
    }
}
