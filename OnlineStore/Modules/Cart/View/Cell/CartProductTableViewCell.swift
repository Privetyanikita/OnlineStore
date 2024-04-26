//
//  CartProductTableViewCell.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 18.04.2024.
//

import UIKit
import SnapKit
import Route

protocol CartProductTableViewCellDelegate: AnyObject {
    func productCheckedStateChanded(_ product: CartProduct)
    func productCountChanged(_ product: CartProduct, value: Int)
    func deleteProductFromCart(_ product: CartProduct)
}

class CartProductTableViewCell: UITableViewCell {
    
    weak var delegate: CartProductTableViewCellDelegate?
    
    private var cartProduct: CartProduct?
    private var cleanImageArray: [String]?
    
    private lazy var checkbox: UIButton = {
        let checkbox = UIButton()
        checkbox.backgroundColor = .customGreen
        checkbox.setImage(UIImage(systemName: "checkmark"), for: .normal)
        checkbox.imageView?.tintColor = .systemBackground
        checkbox.layer.borderColor = UIColor.customLightGrey.cgColor
        checkbox.layer.borderWidth = 0
        checkbox.imageEdgeInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        checkbox.layer.cornerRadius = 6
        checkbox.clipsToBounds = true
        checkbox.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        
        return checkbox
    }()
    
    private let photoImage: UIImageView = {
        let photoImage = UIImageView()
        photoImage.layer.cornerRadius = 6
        photoImage.clipsToBounds = true
        photoImage.contentMode = .scaleAspectFill
        
        return photoImage
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = Font.getFont(.medium, size: 16)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 2
        
        return nameLabel
    }()
    
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = Font.getFont(.medium, size: 16)
        priceLabel.textColor = .label
        priceLabel.textAlignment = .left
        
        return priceLabel
    }()
    
    private lazy var countStepper: CartProductStepper = {
        let stepper = CartProductStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        return stepper
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.imageView?.tintColor = .gray
        deleteButton.layer.borderWidth = 2
        deleteButton.layer.borderColor = UIColor.customLightGrey.cgColor
        deleteButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        return deleteButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        deleteButton.layer.cornerRadius = deleteButton.frame.width / 2
        deleteButton.clipsToBounds = true
    }
    
    func configureCell(with cartProduct: CartProduct) {
        self.cartProduct = cartProduct
        let cleanImageURl = cartProduct.product.images.first!.cleanImageUrl()
        loadImageTableViewCell(url: cleanImageURl, imageView: photoImage)
        //photoImage.kf.setImage(with: URL(string: cartProduct.product.images.first!))
        nameLabel.text = cartProduct.product.title
        priceLabel.configPriceLabel(priceTitle: cartProduct.product.price, type: .left)
        countStepper.setValue(Double(cartProduct.count))
        if !cartProduct.isChecked {
            checkbox.layer.borderWidth = 2
            checkbox.backgroundColor = .systemBackground
        } else {
            checkbox.layer.borderWidth = 0
            checkbox.backgroundColor = .customGreen
        }
    }
    
    private func cleanImagesArray() {
        cleanImageArray = cartProduct?.product.images.map { string in
            var cleanedString = string.cleanImageUrl()
            cleanedString = cleanedString.trimmingCharacters(in:  CharacterSet(charactersIn: "\""))
            return cleanedString
        }
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(checkbox)
        contentView.addSubview(photoImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(countStepper)
        contentView.addSubview(deleteButton)
        contentView.subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        checkbox.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview()
            make.centerY.equalTo(photoImage)
        }
        
        photoImage.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.leading.equalTo(checkbox.snp.trailing).offset(10)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImage.snp.trailing).offset(10)
            make.top.equalTo(photoImage).offset(5)
            make.trailing.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.bottom.equalTo(photoImage).inset(5)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalTo(nameLabel)
            make.bottom.equalTo(priceLabel)
        }
        
        countStepper.snp.makeConstraints { make in
            make.height.equalTo(deleteButton)
            make.width.equalTo(deleteButton).multipliedBy(3)
            make.trailing.equalTo(deleteButton.snp.leading).offset(-10)
            make.bottom.equalTo(deleteButton)
        }
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        print("Delete \(nameLabel.text ?? "unknown") product button tapped")
        guard let cartProduct else { return }
        delegate?.deleteProductFromCart(cartProduct)
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        print("Count Stepper value changed")
        guard let cartProduct else { return }
        if Int(countStepper.value) > cartProduct.count {
            self.delegate?.productCountChanged(cartProduct, value: 1)
        } else {
            self.delegate?.productCountChanged(cartProduct, value: -1)
        }
    }
    
    @objc private func checkboxTapped(_ sender: UIButton) {
        print("Checkbox tapped")
        guard let cartProduct else { return }
        delegate?.productCheckedStateChanded(cartProduct)
    }
}
