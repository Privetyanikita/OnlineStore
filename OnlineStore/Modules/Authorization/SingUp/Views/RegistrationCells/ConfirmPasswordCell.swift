//
//  ConfirmPasswordCell.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 21.04.2024.
//

import UIKit

class ConfirmPasswordCell: BaseRegistrationCell {

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews(
            titletext: Text.confirmPassword,
            textFieldPlaceholder:  Text.confirmYourPassword,
            isSecureTextEntry: true,
            isShowPasswordRevealButton: true
        )
    }
    
    
    required init?(coder: NSCoder) {
        NSCoder.fatalErrorNotImplemented()
    }
}
