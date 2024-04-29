//
//  ManagerProductView.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 24.04.2024.
//

import UIKit
import SnapKit
import Kingfisher

class ManagerProductView: UIView {
    
    var onSelectImageTap: (() -> Void)?
    var onMainActionButtonTap: ((ProductPost?) -> Void)?
    var setDelegate: (() -> (BaseViewController & UISearchBarDelegate & UITextFieldDelegate))? {
        didSet {
            searchBar.delegate = setDelegate?()
            titleField.delegate = setDelegate?()
            priceField.delegate = setDelegate?()
        }
    }
    
    private let flow: ManagerFlow
    private var productToChange: Product? {
        didSet {
            setupUpdateProductLayout()
        }
    }
    private var product: ProductPost?
    private var categories = [Category]() {
        didSet {
            self.category = categories.first?.name ?? ""
            changeProductCategoryButton.showsMenuAsPrimaryAction = true
            changeProductCategoryButton.menu = buttonMenu()
        }
    }
    
    private var category = String() {
        didSet {
            changeProductCategoryButton.configuration?.attributedTitle = AttributedString(category, attributes: AttributeContainer([NSAttributedString.Key.font: Font.getFont(.medium, size: 14)]))
            changeProductCategoryButton.configuration?.image = Image.chevronDown?.resizedImage(Size: CGSize(width: 14, height: 8))
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
    private lazy var imagesLabel = managerProductLabel(title: "Image")
    
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
        descriptionTextView.textContainerInset = .init(top: 10, left: 3, bottom: 10, right: 3)
        
        return descriptionTextView
    }()
    
    private lazy var changeProductCategoryButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        button.configuration?.baseForegroundColor = .label
        button.configuration?.title = category
        button.contentHorizontalAlignment = .fill
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
    
    private let productImage: UIImageView = {
        let productImage = UIImageView()
        productImage.layer.cornerRadius = 8
        productImage.clipsToBounds = true
        productImage.contentMode = .scaleAspectFill
        
        return productImage
    }()
    
    init(flow: ManagerFlow) {
        self.flow = flow
        super.init(frame: .zero)
        setupUI()
        if flow != .addNewProduct {
            setupUpdateProductLayout()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOutsideTF))
        addGestureRecognizer(tap)
        backgroundColor = .systemBackground
        if flow == .updateProduct || flow == .deleteProduct {
            setupFields()
            addSubview(searchBar)
        }
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
        addSubview(productImage)
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
        
        productImage.snp.makeConstraints { make in
            make.top.equalTo(mainStack.snp.bottom).offset(20)
            make.leading.trailing.equalTo(fieldStack)
            make.height.equalTo(128)
        }
        
        mainActionButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(mainStack)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
        }
    }
    
    private func buttonMenu() -> UIMenu {
        var actions = [UIAction]()
        
        for cat in categories {
            let action = UIAction(title: cat.name, image: nil) { action in
                self.category = action.title
            }
            actions.append(action)
        }
        return UIMenu(title: "", options: .displayInline, children: actions)
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
        priceField.text = "\(product.price ?? 0)"
        descriptionTextView.text = product.description
    }
    
    func setupCategories(_ categories: [Category]) {
        self.categories = categories
    }
    
    func setupImage(image: UIImage?) {
        productImage.image = image
        if productImage.image != nil {
            selectImageButton.setTitle("Change image", for: .normal)
        } else {
            selectImageButton.setTitle("Select image", for: .normal)
        }
    }
    
    func setupProductToChange(_ product: Product) {
        self.productToChange = product
    }
    
    private func setupUpdateProductLayout() {
        if let productToChange {
            subviews.forEach({
                $0.isHidden = false
            })
            if flow == .deleteProduct {
                selectImageButton.setTitle("", for: .normal)
            }
            titleField.text = productToChange.title
            priceField.text = String(productToChange.price)
            category = productToChange.category?.name ?? "no category"
            descriptionTextView.text = productToChange.description
            let cleanImageURl = productToChange.images.first!.cleanImageUrl()
            productImage.kf.setImage(with: URL(string: cleanImageURl))
            if productImage.image != nil {
                selectImageButton.setTitle("Change image", for: .normal)
            } else {
                selectImageButton.setTitle("Select image", for: .normal)
            }
            
        } else {
            subviews.forEach({
                if $0 == searchBar || $0 == mainActionButton {
                    return
                } else {
                    $0.isHidden = true
                }
            })
        }
    }
    
    @objc private func tapOutsideTF() {
        descriptionTextView.resignFirstResponder()
    }
    
    @objc private func selectImageButtonTapped(_ sender: UIButton) {
        print("Select image button tapped")
        onSelectImageTap?()
    }
    
    @objc private func mainActionButtonTapped(_ sender: UIButton) {
        print("\(mainActionButton.currentTitle ?? "") button tapped")
        var catID: Int?
        categories.forEach({
            if $0.name == category {
                catID = $0.id
            }
        })
        if let image = productImage.image {
            NetworkManager.shared.uploadImage(image: image) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                    case .success(let url):
                        print(url)
                        product = ProductPost(title: titleField.text, price: Int(priceField.text ?? "0"), description: descriptionTextView.text, categoryID: catID, images: [url])
                        onMainActionButtonTap?(product)
                    case .failure(let error):
                        print(error.localizedDescription)
                        product = ProductPost(title: titleField.text, price: Int(priceField.text ?? "0"), description: descriptionTextView.text, categoryID: catID, images: ["https://placeimg.com/640/480/any"])
                        onMainActionButtonTap?(product)
                    }
                }
            }
        } else {
            onMainActionButtonTap?(product)
        }
    }

}
