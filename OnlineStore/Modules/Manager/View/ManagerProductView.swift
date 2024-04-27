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
    
    var onSelectImageTap: (() -> Void)?
    var onMainActionButtonTap: (() -> Void)?
    
    private let flow: ManagerFlow
    private var product: Product?
    
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
        searchBar.isHidden = true
        
        return searchBar
    }()
    
    private lazy var titleLabel = managerProductLabel(title: "Title")
    private lazy var priceLabel = managerProductLabel(title: "Price")
    private lazy var categoryLabel = managerProductLabel(title: "Category")
    private lazy var descriptionLabel = managerProductLabel(title: "Description")
    private lazy var imagesLabel = managerProductLabel(title: "Images")
    
    private lazy var titleField = managerProductField(placeholder: "Product title")
    private lazy var priceField = managerProductField(placeholder: "Product price", isNumField: true)
    
    private func managerProductLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = Font.getFont(.semiBold, size: 15)
        label.textColor = .label
        
        return label
    }
    
    private func managerProductField(placeholder: String, isNumField: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.font = Font.getFont(.medium, size: 14)
        textField.textColor = .label
        textField.placeholder = placeholder
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.customLightGrey.cgColor
        textField.layer.borderWidth = 2
        if isNumField {
            textField.keyboardType = .numberPad
        }
        let paddingView = UIView(frame: CGRectMake(0, 0, 10, textField.frame.height))
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        
        return textField
    }
    
    private lazy var descriptionTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.font = Font.getFont(.medium, size: 14)
        descriptionTextView.textColor = .label
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.layer.borderColor = UIColor.customLightGrey.cgColor
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return descriptionTextView
    }()
    
    private lazy var changeProductCategoryButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        button.configuration?.baseForegroundColor = .label
        button.configuration?.title = category
        button.contentHorizontalAlignment = .fill
        button.configuration?.image = Image.chevronDown?.resizedImage(Size: CGSize(width: 14, height: 8))
        button.configuration?.imagePlacement = .trailing
        button.configuration?.imagePadding = 5
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.customLightGrey.cgColor
        button.layer.borderWidth = 2
        button.configuration?.attributedTitle = AttributedString(category, attributes: AttributeContainer([NSAttributedString.Key.font: Font.getFont(.medium, size: 14)]))
        
        return button
    }()
    
    private lazy var selectImageButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        button.configuration?.baseForegroundColor = .customGreen
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.customLightGrey.cgColor
        button.layer.borderWidth = 2
        button.configuration?.attributedTitle = AttributedString("Select image", attributes: AttributeContainer([NSAttributedString.Key.font: Font.getFont(.medium, size: 14)]))
        button.addTarget(self, action: #selector(selectImageButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var mainActionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add new product", for: .normal)
        button.titleLabel?.font = Font.getFont(.medium, size: 16)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .customGreen
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(mainActionButtonTapped), for: .touchUpInside)
        
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
        if flow == .updateProduct || flow == .deleteProduct {
            setupFields()
            addSubview(searchBar)
        }
        changeProductCategoryButton.showsMenuAsPrimaryAction = true
        changeProductCategoryButton.menu = buttonMenu()
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, priceLabel, categoryLabel, descriptionLabel, imagesLabel])
        titleStack.axis = .vertical
        titleStack.spacing = 20
        let fieldStack = UIStackView(arrangedSubviews: [titleField, priceField, changeProductCategoryButton, descriptionTextView, selectImageButton])
        fieldStack.axis = .vertical
        fieldStack.spacing = 20
        let mainStack = UIStackView(arrangedSubviews: [titleStack, fieldStack])
        mainStack.axis = .horizontal
        mainStack.spacing = 20
        addSubview(mainStack)
        addSubview(mainActionButton)
        
        titleStack.arrangedSubviews.forEach({
            if $0 != descriptionLabel {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(40)
                    make.width.equalTo(80)
                }
            } else {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(150)
                    make.width.equalTo(80)
                }
            }
        })
        
        fieldStack.arrangedSubviews.forEach({
            if $0 != descriptionTextView {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(40)
                }
            } else {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(150)
                }
            }
        })
        
        if flow != .addNewProduct {
            searchBar.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide).offset(60)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(40)
            }
        }
        
        
        mainStack.snp.makeConstraints { make in
            if flow != .addNewProduct {
                make.top.equalTo(searchBar.snp.bottom).offset(20)
            } else {
                make.top.equalTo(safeAreaLayoutGuide).offset(60)
            }
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        mainActionButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(mainStack)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
        }
    }
    
    private func buttonMenu() -> UIMenu {
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
    
    private func setupFields() {
        searchBar.isHidden = false
        if flow == .updateProduct {
            mainActionButton.setTitle("Update product", for: .normal)
        } else {
            titleField.isUserInteractionEnabled = false
            priceField.isUserInteractionEnabled = false
            changeProductCategoryButton.isUserInteractionEnabled = false
            changeProductCategoryButton.configuration?.image = nil
            changeProductCategoryButton.contentHorizontalAlignment = .leading
            descriptionTextView.isUserInteractionEnabled = false
            selectImageButton.isUserInteractionEnabled = false
            selectImageButton.setTitle("", for: .normal)
            mainActionButton.setTitle("Delete product", for: .normal)
        }
        
        guard let product else { return }
        titleField.text = product.title
        priceField.text = String(product.price)
        descriptionTextView.text = product.description
    }
    
    @objc private func changeProductCategory(_ sender: UIButton) {
        print("Change Product Category button tapped")
        delegate?.changeProductCategoryTapped()
    }
    
    @objc private func selectImageButtonTapped(_ sender: UIButton) {
        print("Change Product Category button tapped")
        onSelectImageTap?()
    }
    
    @objc private func mainActionButtonTapped(_ sender: UIButton) {
        print("\(mainActionButton.currentTitle!) button tapped")
        onMainActionButtonTap?()
    }

}
