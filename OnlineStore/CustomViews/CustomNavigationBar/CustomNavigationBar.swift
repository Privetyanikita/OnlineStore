//
//  CustomNavigationBar.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 16.04.2024.
//

import UIKit
import SnapKit

struct CustomNavigationBarConfiguration {
    var title: String = ""
    var withSearchTextField: Bool = false
    var withLocationView: Bool = false
    var isSetupBackButton: Bool
    var rightButtons: [CustomNavigationBarButtons]
}


protocol SetupCustomNavBarProtocol {
    var customNavigationBar: CustomNavigationBar { get set }
}


enum CustomNavigationBarButtons {
    case shoppingCart
    case notification
}


protocol CustomNavigationBar: CustomNavigationBarProtocol {
    var title: String { get set }
    var backButton: UIButton { get }
    func setupBackButton(_ isSetupBackButton: Bool)
    func setupRightButtons(_ buttons: [CustomNavigationBarButtons])
}


protocol CustomNavigationBarProtocol: AnyObject {
    func setupConfiguration(_ configuration: CustomNavigationBarConfiguration?)
}


final class CustomNavigationBarImplementation: UIView, CustomNavigationBar {
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    let backButton: UIButton = BackButton(type: .system)
    let locationView = LocationView()
    let shoppingCartButton = CustomNavigationBarButton(typeButton: .shoppingCart)
    let notificationButton = CustomNavigationBarButton(typeButton: .notification)
    let searchTextField: UISearchBar = {
        let view = UISearchBar()
        view.textField?.backgroundColor = .clear
        view.clearBackgroundColor()
        view.layer.borderColor = UIColor.secondaryLabel.cgColor
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        return view
    }()
    
    
    init() {
        super.init(frame: .zero)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView(_ countOfLeftButtons: Int, _ isSetupBackButton: Bool) {
        addSubview(titleLabel)
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        let countOfLeftButton = (isSetupBackButton) ? 1 : 0
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8+8*(countOfLeftButton+1)+27*countOfLeftButton)
            make.trailing.equalToSuperview().inset(8+8*(countOfLeftButtons+1)+27*countOfLeftButtons)
        }
    }
    
    
    func setTitle(title: String) {
        self.title = title
    }
    
    
    func setupBackButton(_ isSetupBackButton: Bool) {
        if isSetupBackButton {
            addSubview(backButton)
            backButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(16)
                make.height.width.equalTo(27)
            }
        }
    }
    
    func setupRightButtons(_ buttons: [CustomNavigationBarButtons]) {
        let buttons = buttons
        if !buttons.isEmpty {
            for btn in 0...buttons.count - 1 {
                setupRightButton(button: buttons[btn], count: btn)
            }
        }
    }
    
    
    func setupRightButton(button: CustomNavigationBarButtons, count: Int) {
        let inset = (8+12*(count+1)+27*count)
        switch button {
        case .shoppingCart:
            setupButtonOnView(shoppingCartButton, inset)
        case .notification:
            setupButtonOnView(notificationButton, inset)
        }
    }
    
    
    private func setupButtonOnView(_ button: UIButton, _ inset: Int) {
        addSubview(button)
        
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(inset)
            make.height.width.equalTo(27)
        }
    }
    
    
    private func setupTextField(_ withTextField: Bool,
                                _ rightButtonsCount: Int,
                                _ withBackButton: Bool
                                                        ) {
        if withTextField {
            addSubview(searchTextField)
            searchTextField.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(5)
                make.trailing.equalToSuperview().inset(8+12*(rightButtonsCount+1)+27*rightButtonsCount)
                if withBackButton {
                    make.leading.equalToSuperview().inset(50)
                } else {
                    make.leading.equalToSuperview().inset(16)
                }
            }
        }
    }
    
    
    private func setupLocationView(_ withLocationView: Bool,
                                _ rightButtonsCount: Int,
                                _ withBackButton: Bool
                                                        ) {
        if withLocationView {
            addSubview(locationView)
            locationView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(5)
                make.trailing.equalToSuperview().inset(8+12*(rightButtonsCount+1)+27*rightButtonsCount)
                if withBackButton {
                    make.leading.equalToSuperview().inset(50)
                } else {
                    make.leading.equalToSuperview().inset(16)
                }
            }
        }
    }
    
    
    func setupConfiguration(_ configuration: CustomNavigationBarConfiguration?) {
        guard var configuration else { return }
        
        backgroundColor = .systemBackground
        
        setTitle(title: configuration.title)
        setupView(configuration.rightButtons.count, configuration.isSetupBackButton)
        setupBackButton(configuration.isSetupBackButton)
        setupRightButtons(configuration.rightButtons)
        setupTextField(configuration.withSearchTextField,
                       configuration.rightButtons.count,
                       configuration.isSetupBackButton
        )
        setupLocationView(configuration.withLocationView,
                          configuration.rightButtons.count,
                          configuration.isSetupBackButton)
    }
}
