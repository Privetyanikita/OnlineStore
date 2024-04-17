//
//  CustomNavigationBarButton.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 16.04.2024.
//

import UIKit

final class CustomNavigationBarButton: UIButton {
    
    let typeButton: CustomNavigationBarButtons
    
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

