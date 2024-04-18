//
//  LocationView.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 18.04.2024.
//

import UIKit
import SnapKit

protocol LocationViewDelegate: AnyObject {
    func changeDeliveryAddressTapped()
}

final class LocationView: UIView {
    
     weak var delegate: LocationViewDelegate?
    
    var deliveryAddress = "Salatiga City, Central Java" {
        didSet {
            changeDeliveryAddressButton.configuration?.title = deliveryAddress
        }
    }
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        view.textColor = .label.withAlphaComponent(0.5)
        view.text = Text.deliveryAddress
        return view
    }()
    
    private lazy var changeDeliveryAddressButton: UIButton = {
        let button = UIButton()
        button.configuration                             = .plain()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration?.baseForegroundColor  = .label
        button.configuration?.title                = deliveryAddress
        button.configuration?.titleAlignment       = .leading
        button.configuration?.image                = Image.chevronDown?.resizedImage(Size: CGSize(width: 14, height: 8))
        button.configuration?.imagePlacement       = .trailing
        button.configuration?.imagePadding         = 5
        
        return button
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Methods
    private func setup() {
        backgroundColor = .systemBackground
        
        addSubview(titleLabel)
        addSubview(changeDeliveryAddressButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
     
        changeDeliveryAddressButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        changeDeliveryAddressButton.showsMenuAsPrimaryAction = true
        changeDeliveryAddressButton.menu = buttonMenu()
        //changeDeliveryAddressButton.addTarget(self, action: #selector(changeAddress), for: .touchUpInside)
    }
    
    
    @objc private func changeAddress() {
        print(">> Change Address BTN tapped")
        delegate?.changeDeliveryAddressTapped()
    }
    
    
    func buttonMenu() -> UIMenu {
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
}
