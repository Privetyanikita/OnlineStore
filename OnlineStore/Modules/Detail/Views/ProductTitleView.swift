//
//  ProductTitleView.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 19.04.2024.
//

import UIKit

protocol ProductTitleViewDelegateProtocol: AnyObject{
    func addToWishList()
    func deleteFromWishList()
}

class ProductTitleView: UIView {

    var isFavoriteProduct: Bool = false
    weak var delegate: ProductTitleViewDelegateProtocol?
    
    private let productNameLabel: UILabel = {
        let view = UILabel()
        view.font = Font.getFont(.medium, size: 16)
        view.textColor = .label.withAlphaComponent(0.8)
        return view
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        view.font = Font.getFont(.medium, size: 18)
        view.textColor = .label.withAlphaComponent(0.8)
        return view
    }()
    
    private let favoriteProductButton: UIButton = {
        let view = UIButton()
        view.configuration = .filled()
        view.configuration?.cornerStyle = .capsule
        view.configuration?.baseBackgroundColor = .systemGray6
        view.configuration?.image = Image.emptyHeart
        return view
    }()
    
    
    private let labelStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 6
        view.distribution = .fillProportionally
        view.alignment = .leading
        view.axis = .vertical
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
        addSubview(labelStackView)
        addSubview(favoriteProductButton)
        
        labelStackView.addArrangedSubview(productNameLabel)
        labelStackView.addArrangedSubview(priceLabel)
        
        labelStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(favoriteProductButton.snp.leading)
        }
        
        favoriteProductButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(46)
        }
    }
    
    
    func configure(product name: String, price: Int) {
        productNameLabel.text = name
        priceLabel.configPriceLabel(priceTitle: price, type: .left)
        favoriteProductButton.addTarget(self, action: #selector(isFavoriteTapped), for: .touchUpInside)
    }
    
    
    @objc private func isFavoriteTapped() {
        isFavoriteProduct = !isFavoriteProduct
        favoriteProductButton.configuration?.image = isFavoriteProduct == true ? Image.isLikedHeart : Image.emptyHeart
        if isFavoriteProduct == true{
            delegate?.addToWishList()
        } else {
            delegate?.deleteFromWishList()
        }
    }
}
