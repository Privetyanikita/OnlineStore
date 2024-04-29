//
//  ManagerCategoryView.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 24.04.2024.
//

import UIKit
import SnapKit

class ManagerCategoryView: UIView {

    var onSelectImageTap: (() -> Void)?
    var onMainActionButtonTap: ((CategoryPost?) -> Void)?
    var setDelegate: (() -> (BaseViewController & UISearchBarDelegate & UITextFieldDelegate))? {
        didSet {
            searchBar.delegate = setDelegate?()
            titleField.delegate = setDelegate?()
        }
    }
    
    private let flow: ManagerFlow
    private var category: CategoryPost?
    private var categoryToChange: Category? {
        didSet {
            setupUpdateCategoryLayout()
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = Font.getFont(.semiBold, size: 15)
        label.textColor = .label
        
        return label
    }()
    
    private let titleField: UITextField = {
        let textField = UITextField()
        textField.font = Font.getFont(.medium, size: 14)
        textField.textColor = .label
        textField.placeholder = "Category title"
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.customLightGrey.cgColor
        textField.layer.borderWidth = 2
        let paddingView = UIView(frame: CGRectMake(0, 0, 10, textField.frame.height))
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        
        return textField
    }()
    
    private let imageLabel: UILabel = {
        let label = UILabel()
        label.text = "Image"
        label.font = Font.getFont(.semiBold, size: 15)
        label.textColor = .label
        
        return label
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
        button.setTitle("Create category", for: .normal)
        button.titleLabel?.font = Font.getFont(.medium, size: 16)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .customGreen
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(mainActionButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let categoryImage: UIImageView = {
        let categoryImage = UIImageView()
        categoryImage.layer.cornerRadius = 8
        categoryImage.clipsToBounds = true
        categoryImage.contentMode = .scaleAspectFill
        
        return categoryImage
    }()
    
    init(flow: ManagerFlow) {
        self.flow = flow
        super.init(frame: .zero)
        setupUI()
        if flow != .createCategory {
            setupUpdateCategoryLayout()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        if flow != .createCategory {
            setupFields()
            addSubview(searchBar)
        }
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, imageLabel])
        titleStack.axis = .vertical
        titleStack.spacing = 20
        let fieldStack = UIStackView(arrangedSubviews: [titleField, selectImageButton])
        fieldStack.axis = .vertical
        fieldStack.spacing = 20
        let mainStack = UIStackView(arrangedSubviews: [titleStack, fieldStack])
        mainStack.axis = .horizontal
        mainStack.spacing = 20
        addSubview(mainStack)
        addSubview(categoryImage)
        addSubview(mainActionButton)
        
        if flow != .createCategory {
            searchBar.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide).offset(60)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(40)
            }
        }
        
        titleStack.arrangedSubviews.forEach({
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(50)
            }
        })
        
        fieldStack.arrangedSubviews.forEach({
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        })
        
        mainStack.snp.makeConstraints { make in
            if flow != .createCategory {
                make.top.equalTo(searchBar.snp.bottom).offset(20)
            } else {
                make.top.equalTo(safeAreaLayoutGuide).offset(60)
            }
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        categoryImage.snp.makeConstraints { make in
            make.top.equalTo(mainStack.snp.bottom).offset(20)
            make.leading.trailing.equalTo(fieldStack)
            make.height.equalTo(128)
        }
        
        mainActionButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(mainStack)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
        }
    }
    
    private func setupFields() {
        searchBar.isHidden = false
        if flow == .updateCategory {
            mainActionButton.setTitle("Update category", for: .normal)
        } else {
            titleField.isUserInteractionEnabled = false
            selectImageButton.isUserInteractionEnabled = false
            selectImageButton.setTitle("", for: .normal)
            mainActionButton.setTitle("Delete category", for: .normal)
        }
        
        guard let category else { return }
        titleField.text = category.name
    }
    
    func setupImage(image: UIImage?) {
        categoryImage.image = image
        if categoryImage.image != nil {
            selectImageButton.setTitle("Change image", for: .normal)
        } else {
            selectImageButton.setTitle("Select image", for: .normal)
        }
    }
    
    func setupCategoryToChange(_ category: Category) {
        self.categoryToChange = category
    }
    
    private func setupUpdateCategoryLayout() {
        if let categoryToChange {
            subviews.forEach({
                $0.isHidden = false
            })
            if flow == .deleteCategory {
                selectImageButton.setTitle(nil, for: .normal)
            }
            titleField.text = categoryToChange.name
            
            let cleanImageURl = categoryToChange.image.cleanImageUrl()
            categoryImage.kf.setImage(with: URL(string: cleanImageURl))
            if categoryImage.image != nil {
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
    
    @objc private func selectImageButtonTapped(_ sender: UIButton) {
        print("Select Image button tapped")
        onSelectImageTap?()
    }
    
    @objc private func mainActionButtonTapped(_ sender: UIButton) {
        print("\(mainActionButton.currentTitle ?? "") button tapped")
        
        if let image = categoryImage.image {
            NetworkManager.shared.uploadImage(image: image) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                    case .success(let url):
                        print(url)
                        category = CategoryPost(name: titleField.text, image: url)
                        onMainActionButtonTap?(category)
                    case .failure(let error):
                        print(error.localizedDescription)
                        category = CategoryPost(name: titleField.text, image: "https://placeimg.com/640/480/any")
                        onMainActionButtonTap?(category)
                    }
                }
            }
        } else {
            onMainActionButtonTap?(category)
        }
    }

}
