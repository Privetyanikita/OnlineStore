//
//  ProductDescriptionView.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 20.04.2024.
//

import UIKit
import SnapKit

class ProductDescriptionView: UIView {

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = Font.getFont(.medium, size: 16)
        view.textColor = .label.withAlphaComponent(0.8)
        view.text = Text.descriptionOfProduct
        return view
    }()
    
    private let descriptionTextView: UITextView = {
        let view = UITextView()
        view.font = Font.getFont(.regular, size: 12)
        view.textColor = .label.withAlphaComponent(0.8)
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = .zero
        view.isEditable = false
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        NSCoder.fatalErrorNotImplemented()
    }
    
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(descriptionTextView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo( titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    //MARK: -  Public methods
    func configure(with text: String) {
        descriptionTextView.text = text
    }
}
