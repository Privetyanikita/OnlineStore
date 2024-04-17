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
        deliveryLabel.font = .systemFont(ofSize: 14, weight: .regular)
        deliveryLabel.textColor = .darkGray
        deliveryLabel.textAlignment = .left
        deliveryLabel.text = "Delivery to"
        
        return deliveryLabel
    }()
    
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = .systemFont(ofSize: 14, weight: .regular)
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
        separator.backgroundColor = .customLightGray
        
        return separator
    }()
    
    private let summaryLabel: UILabel = {
        let summaryLabel = UILabel()
        summaryLabel.font = .systemFont(ofSize: 16, weight: .medium)
        summaryLabel.textColor = .darkGray
        summaryLabel.textAlignment = .left
        summaryLabel.text = "Order Summary"
        
        return summaryLabel
    }()
    
    private let totalLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.font = .systemFont(ofSize: 14, weight: .regular)
        totalLabel.textColor = .darkGray
        totalLabel.textAlignment = .left
        totalLabel.text = "Totals"
        
        return totalLabel
    }()
    
    private let sumLabel: UILabel = {
        let sumLabel = UILabel()
        sumLabel.font = .systemFont(ofSize: 14, weight: .regular)
        sumLabel.textColor = .darkGray
        sumLabel.textAlignment = .right
        sumLabel.text = "$ "
        
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
