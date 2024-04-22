//
//  UserNameCell.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 21.04.2024.
//

import UIKit

class UserNameCell: BaseRegistrationCell {

   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews(
            titletext: Text.userName,
            textFieldPlaceholder: Text.enterYourName
        )
        textField.clearButtonMode = .whileEditing
    }
    
    
    required init?(coder: NSCoder) {
        NSCoder.fatalErrorNotImplemented()
    }
}
