//
//  CartView.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

class CartView: UIView {
    
    var tableViewHandler: (UITableViewDataSource & UITableViewDelegate)?
    
    private let deliveryLabel: UILabel = {
        let deliveryLabel = UILabel()
        deliveryLabel.font = Font.getFont(.regular, size: 14)
        deliveryLabel.textColor = .darkGray
        deliveryLabel.textAlignment = .left
        deliveryLabel.text = "Delivery to"
        
        return deliveryLabel
    }()
    
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = Font.getFont(.regular, size: 14)
        locationLabel.textColor = .darkGray
        locationLabel.textAlignment = .right
        locationLabel.text = "Salatiga City, Central Java"
        
        return locationLabel
    }()
    
    private lazy var setLocationButton: UIButton = {
        let setLocationButton = UIButton()
        setLocationButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        setLocationButton.imageView?.tintColor = .darkGray
        
        return setLocationButton
    }()
    
    private let cartTableView: UITableView = {
        let cartTableView = UITableView()
        
        return cartTableView
    }()
    
    private let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .customLightGrey
        
        return separator
    }()
    
    private let summaryLabel: UILabel = {
        let summaryLabel = UILabel()
        summaryLabel.font = Font.getFont(.medium, size: 16)
        summaryLabel.textColor = .darkGray
        summaryLabel.textAlignment = .left
        summaryLabel.text = "Order Summary"
        
        return summaryLabel
    }()
    
    private let totalLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.font = Font.getFont(.regular, size: 14)
        totalLabel.textColor = .darkGray
        totalLabel.textAlignment = .left
        totalLabel.text = "Totals"
        
        return totalLabel
    }()
    
    private let sumLabel: UILabel = {
        let sumLabel = UILabel()
        sumLabel.font = Font.getFont(.regular, size: 14)
        sumLabel.textColor = .darkGray
        sumLabel.textAlignment = .right
        sumLabel.text = "$ 100"
        
        return sumLabel
    }()
    
    init() {
        super.init(frame: .zero)
        cartTableView.dataSource = tableViewHandler
        cartTableView.delegate = tableViewHandler
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
    }
}
