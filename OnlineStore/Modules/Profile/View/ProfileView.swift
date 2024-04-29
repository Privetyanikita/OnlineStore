//
//  ProfileView.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

class ProfileView: UIView {
    
    var onEditPhotoTap: (() -> Void)?
    var onAccountTypeTap: (() -> Void)?
    var onTermsTap: (() -> Void)?
    var onSignOutTap: (() -> Void)?
    
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.contentMode = .scaleAspectFill
        profileImage.backgroundColor = .white
        
        return profileImage
    }()
    
    private lazy var editImageButton: UIButton = {
        let editImageButton = UIButton()
        editImageButton.addTarget(self, action: #selector(editImageButtonTapped), for: .touchUpInside)
        editImageButton.backgroundColor = .customGreen
        editImageButton.layer.borderWidth = 3
        editImageButton.layer.borderColor = UIColor.white.cgColor
        editImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editImageButton.tintColor = .white
        
        return editImageButton
    }()
    
    private let nameField: UITextField = {
        let nameField = UITextField()
        nameField.font = Font.getFont(.medium, size: 16)
        nameField.textColor = .darkGray
        
        return nameField
    }()
    
    private let mailField: UITextField = {
        let mailField = UITextField()
        mailField.font = Font.getFont(.regular, size: 14)
        mailField.textColor = .gray
        
        return mailField
    }()
    
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.isSecureTextEntry = true
        passwordField.font = Font.getFont(.regular, size: 14)
        passwordField.textColor = .gray
        
        return passwordField
    }()
    
    private lazy var accountTypeButton: UIButton = {
        let accountTypeButton = UIButton(title: "Type of account", rightPicName: "chevron.right")
        accountTypeButton.addTarget(self, action: #selector(accountTypeButtonTapped), for: .touchUpInside)
        
        return accountTypeButton
    }()
    
    private lazy var termsButton: UIButton = {
        let termsButton = UIButton(title: "Terms & Conditions", rightPicName: "chevron.right")
        termsButton.addTarget(self, action: #selector(termsButtonTapped), for: .touchUpInside)
        
        return termsButton
    }()
    
    private lazy var signOutButton: UIButton = {
        let signOutButton = UIButton(title: "Sign Out", rightPicName: "rectangle.portrait.and.arrow.right")
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        
        return signOutButton
    }()
    
    init(user: ProfileUser) {
        super.init(frame: .zero)
        setupUI(with: user)
        dismissKeyboardTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        editImageButton.layer.cornerRadius = editImageButton.frame.width / 2
        editImageButton.clipsToBounds = true
    }
    
    private func dismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing(_:)))
        addGestureRecognizer(tap)
    }
    
    func setupImage(_ image: UIImage?) {
        
    }
    
    private func setupUI(with user: ProfileUser) {
        backgroundColor = .white
        if let photo = user.photo {
            profileImage.image = photo
        } else {
            profileImage.image = .onlineStoreIconGreen
        }
        nameField.text = user.name
        mailField.text = user.mail
        passwordField.text = user.password
        let usernameStack = UIStackView(arrangedSubviews: [nameField, mailField, passwordField])
        usernameStack.axis = .vertical
        let buttonStack = UIStackView(arrangedSubviews: [accountTypeButton, termsButton, signOutButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 20
        addSubview(profileImage)
        addSubview(editImageButton)
        addSubview(usernameStack)
        addSubview(buttonStack)
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.top.equalTo(safeAreaLayoutGuide).offset(58)
            make.leading.equalToSuperview().offset(28)
        }
        
        editImageButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.bottom.equalTo(profileImage)
            make.trailing.equalTo(profileImage).offset(5)
        }
        
        usernameStack.snp.makeConstraints { make in
            make.leading.equalTo(editImageButton.snp.trailing).offset(35)
            make.centerY.equalTo(profileImage)
            make.trailing.equalToSuperview().inset(28)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.leading.equalTo(profileImage)
            make.trailing.equalTo(usernameStack)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(22)
        }
        
    }
    
    @objc private func editImageButtonTapped(_ sender: UIButton) {
        print("Edit image button tapped")
        onEditPhotoTap?()
    }
    
    @objc private func accountTypeButtonTapped(_ sender: UIButton) {
        print("Account type button tapped")
        onAccountTypeTap?()
    }
    
    @objc private func termsButtonTapped(_ sender: UIButton) {
        print("Terms & Conditions button tapped")
        onTermsTap?()
    }
    
    @objc private func signOutButtonTapped(_ sender: UIButton) {
        print("Sign Out button tapped")
        onSignOutTap?()
    }
}

extension UIButton {
    
    convenience init (title: String, rightPicName: String) {
        self.init()
        setupUIForProfileButton(title: title, rightPicName: rightPicName)
    }
    
    private func setupUIForProfileButton(title: String, rightPicName: String) {
        backgroundColor = .customLightGrey
        layer.cornerRadius = 12
        let buttonTitle = UILabel()
        buttonTitle.font = Font.getFont(.semiBold, size: 16)
        buttonTitle.textColor = .gray
        buttonTitle.textAlignment = .left
        buttonTitle.text = title
        let rightIndicator = UIImageView()
        rightIndicator.tintColor = .gray
        rightIndicator.image = UIImage(systemName: rightPicName)
        addSubview(buttonTitle)
        addSubview(rightIndicator)
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        buttonTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        rightIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.top.bottom.equalToSuperview().inset(16)
        }
        
    }
}
