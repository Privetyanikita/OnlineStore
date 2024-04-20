//
//  CartProductStepper.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 20.04.2024.
//

import UIKit
import SnapKit

class CartProductStepper: UIControl {
    
    private (set) var value: Double = 0
    
    private lazy var plusButton = stepperButton(text: "+", value: 1)
    private lazy var minusButton = stepperButton(text: "-", value: -1)
    
    private lazy var counterLabel: UILabel = {
        let counterLabel = UILabel()
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.textAlignment = .center
        counterLabel.text = "0"
        
        return counterLabel
    }()
    
    private lazy var container: UIStackView = {
        let container = UIStackView()
        container.distribution = .fillEqually
        container.translatesAutoresizingMaskIntoConstraints = false
        
        return container
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
        plusButton.layer.cornerRadius = bounds.size.height / 2
        minusButton.layer.cornerRadius = bounds.size.height / 2
    }
    
    func setValue(_ newValue: Double) {
        value = newValue
        counterLabel.text = String(value.formatted())
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        [minusButton, counterLabel, plusButton].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        [minusButton, counterLabel, plusButton].forEach(container.addArrangedSubview)
        addSubview(container)
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func didPressedStepper(value: Double) {
        updateValue(value)
    }
    
    private func updateValue(_ newValue: Double) {
        guard (1...100).contains(value + newValue) else { return }
        value += newValue
        counterLabel.text = String(value.formatted())
        sendActions(for: .valueChanged)
    }
    
    private func stepperButton(text: String, value: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.tag = value
        button.titleLabel?.font = Font.getFont(.medium, size: 16)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.gray.withAlphaComponent(0.5), for: .highlighted)
        button.backgroundColor = .systemBackground
        button.layer.borderColor = UIColor.customLightGrey.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        didPressedStepper(value: Double(sender.tag))
    }
}
