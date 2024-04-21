//
//  PaymentSuccessView.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 20.04.2024.
//

import UIKit
import SnapKit

class PaymentSuccessView: UIView {
    
    var onContinueTap: (() -> Void)?
    
    private let successImage: UIImageView = {
        let successImage = UIImageView()
        successImage.image = .onlineStoreIconGreen
        successImage.contentMode = .scaleAspectFit
        
        return successImage
    }()
    
    private let congratsLabel: UILabel = {
        let congratsLabel = UILabel()
        congratsLabel.font = Font.getFont(.medium, size: 18)
        congratsLabel.textColor = .label
        congratsLabel.textAlignment = .center
        congratsLabel.numberOfLines = 2
        congratsLabel.text = "Congrats! Your payment is succeed!"
        
        return congratsLabel
    }()
    
    private let thanksLabel: UILabel = {
        let thanksLabel = UILabel()
        thanksLabel.font = Font.getFont(.regular, size: 12)
        thanksLabel.textColor = .label
        thanksLabel.textAlignment = .center
        thanksLabel.numberOfLines = 2
        thanksLabel.text = "Track your order or just chat directly to the seller. Download order summary below."
        
        return thanksLabel
    }()

    private let invoiceField: UITextField = {
        let invoiceField = UITextField(title: "order_invoice", leftPicName: "doc.text.fill", rightPicName: "arrow.down.to.line")
        
        return invoiceField
    }()
    
    private lazy var continueButton: UIButton = {
        let continueButton = UIButton()
        continueButton.backgroundColor = .customGreen
        continueButton.layer.cornerRadius = 4
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = Font.getFont(.medium, size: 14)
        continueButton.titleLabel?.textColor = .white
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        return continueButton
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
        addSubview(successImage)
        addSubview(congratsLabel)
        addSubview(thanksLabel)
        addSubview(invoiceField)
        addSubview(continueButton)
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        successImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.height.width.equalTo(140)
            make.centerX.equalToSuperview()
        }
        
        congratsLabel.snp.makeConstraints { make in
            make.top.equalTo(successImage.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        
        thanksLabel.snp.makeConstraints { make in
            make.top.equalTo(congratsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(congratsLabel)
        }
        
        invoiceField.snp.makeConstraints { make in
            make.top.equalTo(thanksLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(thanksLabel)
        }
        
        continueButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.top.equalTo(invoiceField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc private func continueButtonTapped(_ sender: UIButton) {
        print("Continue button tapped")
        onContinueTap?()
    }
}
