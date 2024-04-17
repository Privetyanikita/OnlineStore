//
//  PhotoEditView.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 16.04.2024.
//

import UIKit
import SnapKit

class PhotoEditView: UIView {
    
    var onTakePhotoTap: (() -> Void)?
    var onChooseFileTap: (() -> Void)?
    var onDeletePhotoTap: (() -> Void)?
    
    private let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        
        return blurView
    }()
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 12
        backgroundView.layer.shadowRadius = 12
        backgroundView.layer.shadowOpacity = 0.3
        backgroundView.layer.shadowColor = UIColor.darkGray.cgColor
        
        return backgroundView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .center
        titleLabel.text = "Change your picture"
        
        return titleLabel
    }()
    
    private let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .customLightGray
        
        return separator
    }()
    
    private lazy var takePhotoButton: UIButton = {
        let takePhotoButton = UIButton(title: "Take a photo", leftPicName: "camera.fill", color: .darkGray)
        takePhotoButton.addTarget(self, action: #selector(takePhotoButtonTapped), for: .touchUpInside)
        
        return takePhotoButton
    }()
    
    private lazy var chooseFileButton: UIButton = {
        let chooseFileButton = UIButton(title: "Choose from your file", leftPicName: "folder.fill", color: .darkGray)
        chooseFileButton.addTarget(self, action: #selector(chooseFileButtonTapped), for: .touchUpInside)
        
        return chooseFileButton
    }()
    
    private lazy var deletePhotoButton: UIButton = {
        let deletePhotoButton = UIButton(title: "Delete Photo", leftPicName: "trash.fill", color: .red)
        deletePhotoButton.addTarget(self, action: #selector(deletePhotoButtonTapped), for: .touchUpInside)
        
        return deletePhotoButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let photoEditbuttonStack = UIStackView(arrangedSubviews: [takePhotoButton, chooseFileButton, deletePhotoButton])
        photoEditbuttonStack.spacing = 20
        photoEditbuttonStack.axis = .vertical
        addSubview(blurView)
        addSubview(backgroundView)
        addSubview(titleLabel)
        addSubview(separator)
        addSubview(photoEditbuttonStack)
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(backgroundView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView)
            make.top.equalTo(backgroundView).offset(20)
        }
        
        separator.snp.makeConstraints { make in
            make.leading.trailing.equalTo(backgroundView)
            make.height.equalTo(2)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        photoEditbuttonStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(backgroundView).inset(16)
            make.top.equalTo(separator.snp.bottom).offset(20)
        }
    }
    
    @objc private func takePhotoButtonTapped(_ sender: UIButton) {
        print("Take Photo button tapped")
        onTakePhotoTap?()
    }
    
    @objc private func chooseFileButtonTapped(_ sender: UIButton) {
        print("Choose from File button tapped")
        onChooseFileTap?()
    }
    
    @objc private func deletePhotoButtonTapped(_ sender: UIButton) {
        print("Delete Photo button tapped")
        onDeletePhotoTap?()
    }

}

extension UIButton {
    
    convenience init(title: String, leftPicName: String, color: UIColor) {
        self.init()
        setupEditPhotoButtonUI(title: title, leftPicName: leftPicName, color: color)
    }
 
    private func setupEditPhotoButtonUI(title: String, leftPicName: String, color: UIColor) {
        backgroundColor = .customLightGray
        layer.cornerRadius = 12
        let leftPic = UIImageView()
        leftPic.image = UIImage(systemName: leftPicName)
        leftPic.tintColor = color
        let buttonTitle = UILabel()
        buttonTitle.font = .systemFont(ofSize: 16, weight: .medium)
        buttonTitle.textColor = color
        buttonTitle.textAlignment = .left
        buttonTitle.text = title
        addSubview(leftPic)
        addSubview(buttonTitle)
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        NSLayoutConstraint.activate([
            leftPic.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            leftPic.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            leftPic.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            heightAnchor.constraint(equalToConstant: 60),
            buttonTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonTitle.leadingAnchor.constraint(equalTo: leftPic.trailingAnchor, constant: 18)
        ])
    }
}

