//
//  CartView.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

class CartView: UIView {
    
    var cellToRegister: (() -> UITableViewCell.Type)?
    var tableViewHandler: (UITableViewDataSource & UITableViewDelegate)?
    var onPayTap: (() -> Void)?
    
    var totalSum: Int = 0 {
        didSet {
            sumLabel.configPriceLabel(priceTitle: totalSum, type: .left)
        }
    }
    
    private var deliveryAddress = "Salatiga City, Central Java" {
        didSet {
            changeDeliveryAddressButton.configuration?.title = deliveryAddress
        }
    }
    
    private let deliveryLabel: UILabel = {
        let deliveryLabel = UILabel()
        deliveryLabel.font = Font.getFont(.regular, size: 14)
        deliveryLabel.textColor = .label
        deliveryLabel.textAlignment = .left
        deliveryLabel.text = "Delivery to"
        
        return deliveryLabel
    }()
    
    private lazy var changeDeliveryAddressButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration?.baseForegroundColor = .label
        button.configuration?.title = deliveryAddress
        button.configuration?.titleAlignment = .leading
        button.configuration?.image = Image.chevronDown?.resizedImage(Size: CGSize(width: 14, height: 8))
        button.configuration?.imagePlacement = .trailing
        button.configuration?.imagePadding = 5
        button.configuration?.attributedTitle = AttributedString(deliveryAddress, attributes: AttributeContainer([NSAttributedString.Key.font: Font.getFont(.regular, size: 14)]))
        
        return button
    }()
    
    private let cartTableView: UITableView = {
        let cartTableView = UITableView()
        cartTableView.separatorStyle = .none
        cartTableView.backgroundColor = .clear
        cartTableView.rowHeight = UITableView.automaticDimension
        cartTableView.showsVerticalScrollIndicator = false
        
        return cartTableView
    }()
    
    private let separatorTop: UIView = {
        let separator = UIView()
        separator.backgroundColor = .customLightGrey
        
        return separator
    }()
    
    private let separatorDown: UIView = {
        let separator = UIView()
        separator.backgroundColor = .customLightGrey
        
        return separator
    }()
    
    private let summaryLabel: UILabel = {
        let summaryLabel = UILabel()
        summaryLabel.font = Font.getFont(.medium, size: 16)
        summaryLabel.textColor = .label
        summaryLabel.textAlignment = .left
        summaryLabel.text = "Order Summary"
        
        return summaryLabel
    }()

    private let totalLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.font = Font.getFont(.regular, size: 14)
        totalLabel.textColor = .label
        totalLabel.textAlignment = .left
        totalLabel.text = "Totals"
        
        return totalLabel
    }()
    
    private let sumLabel: UILabel = {
        let sumLabel = UILabel()
        sumLabel.font = Font.getFont(.regular, size: 14)
        sumLabel.textColor = .label
        sumLabel.textAlignment = .right
        
        return sumLabel
    }()
    
    private lazy var payButton: UIButton = {
        let payButton = UIButton()
        payButton.backgroundColor = .customGreen
        payButton.layer.cornerRadius = 4
        payButton.setTitle("Select payment method", for: .normal)
        payButton.titleLabel?.font = Font.getFont(.medium, size: 16)
        payButton.titleLabel?.textColor = .white
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        
        return payButton
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cartTableView.reloadData()
    }
    
    func configureTableView() {
        cartTableView.register(cellToRegister?() ?? UITableViewCell.self, forCellReuseIdentifier: "CartProductCell")
        cartTableView.dataSource = tableViewHandler
        cartTableView.delegate = tableViewHandler
    }
    
    private func buttonMenu() -> UIMenu {
        let address1 = UIAction(title: "Banyumas Regency, Central Java", image: nil) { action in
            self.deliveryAddress = action.title
        }
        
        let address2 = UIAction(title: "Semarang City, Central Java", image: nil) { action in
            self.deliveryAddress = action.title
        }
        
        let address3 = UIAction(title: "Tegal City, Central Java", image: nil) { action in
            self.deliveryAddress = action.title
        }
        
        let address4 = UIAction(title: "Wonogiri Regency, Central Java", image: nil) { action in
            self.deliveryAddress = action.title
        }
        
        let address5 = UIAction(title: "Temanggung Regency, Central Java", image: nil) { action in
            self.deliveryAddress = action.title
        }
        
        return UIMenu(title: "", options: .displayInline, children: [
            address1,
            address2,
            address3,
            address4,
            address5
        ])
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        changeDeliveryAddressButton.showsMenuAsPrimaryAction = true
        changeDeliveryAddressButton.menu = buttonMenu()
        
        addSubview(deliveryLabel)
        addSubview(changeDeliveryAddressButton)
        addSubview(separatorTop)
        addSubview(cartTableView)
        addSubview(separatorDown)
        addSubview(summaryLabel)
        addSubview(totalLabel)
        addSubview(sumLabel)
        addSubview(payButton)
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        deliveryLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(64)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        changeDeliveryAddressButton.snp.makeConstraints { make in
            make.top.equalTo(deliveryLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        separatorTop.snp.makeConstraints { make in
            make.top.equalTo(deliveryLabel.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(2)
        }
        
        payButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(75)
            make.leading.equalTo(payButton)
        }
        
        sumLabel.snp.makeConstraints { make in
            make.bottom.equalTo(totalLabel)
            make.trailing.equalTo(payButton)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(100)
            make.leading.equalTo(totalLabel)
        }
        
        separatorDown.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(125)
            make.height.equalTo(2)
            make.width.equalToSuperview()
        }
        
        cartTableView.snp.makeConstraints { make in
            make.top.equalTo(separatorTop.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(separatorDown.snp.top)
        }
    }
    
    @objc private func payButtonTapped(_ sender: UIButton) {
        print("Pay button tapped")
        onPayTap?()
    }
}
