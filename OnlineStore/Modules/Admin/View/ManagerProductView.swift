//
//  ManagerProductView.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 24.04.2024.
//

import UIKit
import SnapKit

protocol ManagerProductViewDelegate: AnyObject {
    func changeProductCategoryTapped()
}

class ManagerProductView: UIView {
    
    private let flow: ManagerFlow
    
    weak var delegate: ManagerProductViewDelegate?
    
    private var category = "Electronics" {
        didSet {
            changeProductCategoryButton.configuration?.attributedTitle = AttributedString(category, attributes: AttributeContainer([NSAttributedString.Key.font: Font.getFont(.medium, size: 14)]))
        }
    }
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.textField?.backgroundColor = .clear
        searchBar.clearBackgroundColor()
        searchBar.layer.borderColor = UIColor.customLightGrey.cgColor
        searchBar.layer.cornerRadius = 4
        searchBar.layer.borderWidth = 2
        
        return searchBar
    }()
    
    private lazy var titleLabel = managerProductLabel(title: "Title")
    private lazy var priceLabel = managerProductLabel(title: "Price")
    private lazy var categoryLabel = managerProductLabel(title: "Category")
    private lazy var descriptionLabel = managerProductLabel(title: "Description")
    private lazy var imagesLabel = managerProductLabel(title: "Images")
    
    private lazy var titleField = managerProductField(isNumField: false)
    private lazy var priceField = managerProductField(isNumField: true)
    private lazy var descriptionField = managerProductField(isNumField: false)
    private lazy var imagesField = managerProductField(isNumField: false)
    
    private func managerProductLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = Font.getFont(.semiBold, size: 15)
        label.textColor = .label
        
        return label
    }
    
    private func managerProductField(isNumField: Bool) -> UITextField {
        let textField = UITextField()
        textField.font = Font.getFont(.medium, size: 14)
        textField.textColor = .label
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.customLightGrey.cgColor
        textField.layer.borderWidth = 2
        if isNumField {
            textField.keyboardType = .numberPad
        }
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 245).isActive = true
        
        return textField
    }
    
    private lazy var changeProductCategoryButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        button.configuration?.baseForegroundColor = .label
        button.configuration?.title = category
        button.configuration?.titleAlignment = .leading
        button.configuration?.image = Image.chevronDown?.resizedImage(Size: CGSize(width: 14, height: 8))
        button.configuration?.imagePlacement = .trailing
        button.configuration?.imagePadding = 5
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.customLightGrey.cgColor
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 245).isActive = true
        button.configuration?.attributedTitle = AttributedString(category, attributes: AttributeContainer([NSAttributedString.Key.font: Font.getFont(.medium, size: 14)]))
        
        return button
    }()
    
    init(flow: ManagerFlow) {
        self.flow = flow
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        changeProductCategoryButton.showsMenuAsPrimaryAction = true
        changeProductCategoryButton.menu = buttonMenu()
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, titleField])
        let priceStack = UIStackView(arrangedSubviews: [priceLabel, priceField])
        let categoryStack = UIStackView(arrangedSubviews: [categoryLabel, changeProductCategoryButton])
        let descriptionStack = UIStackView(arrangedSubviews: [descriptionLabel, descriptionField])
        let imagesStack = UIStackView(arrangedSubviews: [imagesLabel, imagesField])
        let subviews = [titleStack, priceStack, categoryStack, descriptionStack, imagesStack]
        subviews.forEach({
            $0.axis = .horizontal
            $0.spacing = 20
        })
        let mainStack = UIStackView(arrangedSubviews: subviews)
        mainStack.axis = .vertical
        mainStack.spacing = 20
        addSubview(searchBar)
        addSubview(mainStack)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        mainStack.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.equalTo(searchBar)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func buttonMenu() -> UIMenu {
        let category1 = UIAction(title: "Clothes", image: nil) { action in
            self.category = action.title
        }
        
        let category2 = UIAction(title: "Furniture", image: nil) { action in
            self.category = action.title
        }
        
        let category3 = UIAction(title: "Shoes", image: nil) { action in
            self.category = action.title
        }
        
        let category4 = UIAction(title: "Miscellaneous", image: nil) { action in
            self.category = action.title
        }
        
        let category5 = UIAction(title: "Books", image: nil) { action in
            self.category = action.title
        }
        
        return UIMenu(title: "", options: .displayInline, children: [
            category1,
            category2,
            category3,
            category4,
            category5
        ])
    }
    
    @objc private func changeProductCategory() {
        print("Change Product Category button tapped")
        delegate?.changeProductCategoryTapped()
    }

}
