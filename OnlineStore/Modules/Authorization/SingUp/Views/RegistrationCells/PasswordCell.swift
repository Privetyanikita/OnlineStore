//
//  PasswordCell.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 21.04.2024.
//

import UIKit

class PasswordCell: BaseRegistrationCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews(
            titletext: Text.password,
            textFieldPlaceholder:  Text.enterYourPassword,
            isSecureTextEntry: true,
            isShowPasswordRevealButton: true
        )
    }
    
    
    required init?(coder: NSCoder) {
        NSCoder.fatalErrorNotImplemented()
    }
}
