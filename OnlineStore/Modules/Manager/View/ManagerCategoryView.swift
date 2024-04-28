//
//  ManagerCategoryView.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 24.04.2024.
//

import UIKit
import SnapKit

class ManagerCategoryView: UIView {

    var onMainActionButtonTap: (() -> Void)?
    
    private let flow: ManagerFlow
    private var category: Category?
    
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
        if flow == .updateCategory || flow == .deleteCategory {
            setupFields()
            addSubview(searchBar)
        }
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, titleField])
        titleStack.axis = .horizontal
        titleStack.spacing = 20
        addSubview(titleStack)
        addSubview(mainActionButton)
        
        titleStack.arrangedSubviews.forEach({
            if $0 != titleLabel {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(40)
                }
            } else {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(40)
                    make.width.equalTo(30)
                }
            }
        })
        
        if flow != .createCategory {
            searchBar.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide).offset(60)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(40)
            }
        }
        
        titleStack.snp.makeConstraints { make in
            if flow != .createCategory {
                make.top.equalTo(searchBar.snp.bottom).offset(20)
            } else {
                make.top.equalTo(safeAreaLayoutGuide).offset(60)
            }
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        mainActionButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleStack)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
        }
    }
    
    private func setupFields() {
        searchBar.isHidden = false
        if flow == .updateCategory {
            mainActionButton.setTitle("Update category", for: .normal)
        } else {
            titleField.isUserInteractionEnabled = false
            mainActionButton.setTitle("Delete category", for: .normal)
        }
        
        guard let category else { return }
        titleField.text = category.name
    }
    
    @objc private func mainActionButtonTapped(_ sender: UIButton) {
        print("\(mainActionButton.currentTitle!) button tapped")
        onMainActionButtonTap?()
    }
}
