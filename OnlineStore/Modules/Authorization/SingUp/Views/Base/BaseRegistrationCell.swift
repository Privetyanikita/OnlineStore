//
//  BaseRegistrationCell.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 21.04.2024.
//

import UIKit
import SnapKit

class BaseRegistrationCell: UITableViewCell {

    private let titleLabel  = UILabel()
    let textField           = CustomTextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupHierarchy()
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        NSCoder.fatalErrorNotImplemented()
    }

    
    private func setupViews() {
        selectionStyle = .none
        
        titleLabel.font                  = Font.getFont(.regular, size: 14)
        titleLabel.textColor             = .secondaryLabel
        titleLabel.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        
        textField.rightViewMode          = .always
        textField.textContentType        = .oneTimeCode
        textField.autocorrectionType     = .no
        textField.spellCheckingType      = .no
        textField.autocapitalizationType = .none
        textField.background             = UIImage.imageWithColor(color: .systemGray6, size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
        
    }
    
    
    private func setupHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
    }
    
    
    private func setupLayout() {
        let topOffset: CGFloat = 8
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topOffset)
            make.leading.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(topOffset)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addPasswordRevealButton() -> UIButton {
        let passwordRevealButton = UIButton(type: .custom)
        let eyeSlashImage = Image.hide
        passwordRevealButton.setImage(eyeSlashImage, for: .normal)
        passwordRevealButton.addTarget(self, action: #selector(toggleSecureTextEntry),
            for: .touchUpInside)
        passwordRevealButton.sizeToFit()
        
        return passwordRevealButton
    }
    
    
    private func assignPasswordRevealButtonToTheTextfield() {
        textField.rightView = addPasswordRevealButton()
    }
    
    
    @objc private func toggleSecureTextEntry() {
        textField.isSecureTextEntry = !textField.isSecureTextEntry
    }
    

    //MARK: - Public functions
    func setupSubviews(
        titletext: String,
        textFieldPlaceholder: String,
        isSecureTextEntry: Bool = false,
        isShowPasswordRevealButton: Bool = false
    ) {
        titleLabel.text             = titletext
        textField.placeholder       = textFieldPlaceholder
        textField.isSecureTextEntry = isSecureTextEntry
        
        if isShowPasswordRevealButton {
            assignPasswordRevealButtonToTheTextfield()
        }
    }
}
