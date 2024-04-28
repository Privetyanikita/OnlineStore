//
//  ManagerView.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 24.04.2024.
//

import UIKit
import SnapKit

class ManagerView: UIView {
    
    var onAddNewProductTap: (() -> Void)?
    var onUpdateProductTap: (() -> Void)?
    var onDeleteProductTap: (() -> Void)?
    var onCreateCategoryTap: (() -> Void)?
    var onUpdateCategoryTap: (() -> Void)?
    var onDeleteCategoryTap: (() -> Void)?
    
    private lazy var addNewProductButton = managerButton(title: Text.addNewProduct, action: #selector(addNewProductButtonTapped))
    private lazy var updateProductButton = managerButton(title: Text.updateProduct, action: #selector(updateProductButtonTapped))
    private lazy var deleteProductButton = managerButton(title: Text.deleteProduct, action: #selector(deleteProductButtonTapped))
    private lazy var createCategoryButton = managerButton(title: Text.createCategory, action: #selector(createCategoryButtonTapped))
    private lazy var updateCategoryButton = managerButton(title: Text.updateCategory, action: #selector(updateCategoryButtonTapped))
    private lazy var deleteCategoryButton = managerButton(title: Text.deleteCategory, action: #selector(deleteCategoryButtonTapped))
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        let stack = UIStackView(arrangedSubviews: [addNewProductButton, updateProductButton, deleteProductButton, createCategoryButton, updateCategoryButton, deleteCategoryButton])
        stack.axis = .vertical
        stack.spacing = 24
        addSubview(stack)
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        stack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(safeAreaLayoutGuide).offset(68)
        }
    }
    
    private func managerButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = Font.getFont(.medium, size: 16)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .customGreen
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return button
    }
    
    @objc private func addNewProductButtonTapped(_ sender: UIButton) {
        print("Add New Product button tapped")
        onAddNewProductTap?()
    }
    
    @objc private func updateProductButtonTapped(_ sender: UIButton) {
        print("Update Product button tapped")
        onUpdateProductTap?()
    }
    
    @objc private func deleteProductButtonTapped(_ sender: UIButton) {
        print("Delete Product button tapped")
        onDeleteProductTap?()
    }
    
    @objc private func createCategoryButtonTapped(_ sender: UIButton) {
        print("Create Category button tapped")
        onCreateCategoryTap?()
    }
    
    @objc private func updateCategoryButtonTapped(_ sender: UIButton) {
        print("Update Category button tapped")
        onUpdateCategoryTap?()
    }
    
    @objc private func deleteCategoryButtonTapped(_ sender: UIButton) {
        print("Delete Category button tapped")
        onDeleteCategoryTap?()
    }
    
}
