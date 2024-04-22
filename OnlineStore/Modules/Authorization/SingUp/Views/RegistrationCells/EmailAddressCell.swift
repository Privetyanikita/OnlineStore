//
//  EmailAddressCell.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 21.04.2024.
//

import UIKit

class EmailAddressCell: BaseRegistrationCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews(
            titletext: Text.email,
            textFieldPlaceholder: Text.enterYourEmail
        )
        textField.clearButtonMode = .whileEditing
        textField.keyboardType    = .emailAddress
    }
    
    
    required init?(coder: NSCoder) {
        NSCoder.fatalErrorNotImplemented()
    }
}
