//
//  ProductBottomView.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 21.04.2024.
//

import UIKit

protocol ProductBottomViewDelegate: AnyObject{
    func goTocart()
    func buyNow()
}

class ProductBottomView: UIView {
    
    weak var delegate: ProductBottomViewDelegate?

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.customLightGrey
        
        return view
    }()

    private let addToCartButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        button.configuration?.title = Text.addToCart
        button.configuration?.baseForegroundColor = .white
        button.configuration?.baseBackgroundColor = Color.customGreen
        
        return button
    }()
    
    private let buyNowButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        button.configuration?.title = Text.buyNow
        button.configuration?.baseForegroundColor = .black.withAlphaComponent(0.8)
        button.configuration?.baseBackgroundColor = Color.customLightGrey
     
        return button
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.spacing = 16
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addTargetButtons()
    }
    
    private func addTargetButtons(){
        buyNowButton.addTarget(self, action: #selector(tappedBuyNow), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(tappedAddToCart), for: .touchUpInside)
    }
    
    @objc private func tappedAddToCart(){
        delegate?.goTocart()
    }
    
    @objc private func tappedBuyNow(){
        delegate?.buyNow()
    }
    
    
    required init?(coder: NSCoder) {
        NSCoder.fatalErrorNotImplemented()
    }
    
    
    private func setup() {
        addSubview(separatorView)
        addSubview(stackView)
        stackView.addArrangedSubview(addToCartButton)
        stackView.addArrangedSubview(buyNowButton)
        
        separatorView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(22)
            make.trailing.equalToSuperview().inset(22)
            make.height.equalTo(45)
        }
        
    }
}
