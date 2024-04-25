//
//  CustomNavigationBarButton.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 16.04.2024.
//

import UIKit

final class CustomNavigationBarButton: UIButton {
    
    let typeButton: CustomNavigationBarButtons
    
    lazy var badgeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = Font.getFont(.regular, size: 8)
        label.backgroundColor = .systemRed
        
        return label
    }()
    
    // MARK: - Init
    init(typeButton: CustomNavigationBarButtons) {
        self.typeButton = typeButton
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setup() {
        var image: UIImage? = nil
        switch typeButton {
            
        case .notification:
            image = Image.bell
        case .shoppingCart:
            image = Image.systemCart
            addSubview(badgeLabel)
            badgeLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(4)
                make.top.equalToSuperview().inset(-2)
                make.height.width.equalTo(12)
            }
        }
        setImage(image, for: .normal)
        tintColor = .systemGray
        addTarget(self, action: #selector(animateButton), for: .touchUpInside)
        
    }

    override var isEnabled: Bool {
        willSet {
            tintColor = newValue ? .systemGray : .systemGray6
        }
    }

    @objc fileprivate func animateButton(button: UIButton) {
        self.animate(deep: .large)
    }
}

