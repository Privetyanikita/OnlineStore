//
//  ProductCell.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//


import UIKit

enum AddToCartCellEvent {
    case addToCartTapped
    case addToWishList
}

class ProductCell: UICollectionViewCell {
    static let resuseID = String(describing: ProductCell.self)
    var onButtonTap: ((AddToCartCellEvent) -> Void)?

    private let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.configImageView(cornerRadius: 5, contentMode: .scaleAspectFill)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.configLabel(font: Font.getFont(.regular, size: 12), lines: 1, alignment: .left, color: UIColor.lightGray)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.configLabel(font: Font.getFont(.semiBold, size: 14), lines: 1, alignment: .left, color: UIColor.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(named: "CustomGreen")
        button.setTitle("Add to cart", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = Font.getFont(.regular, size: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let wishListButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "CustomGreen")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        priceLabel.text = nil
        productImage.image = nil
        configShandowContentView(color:  nil, opacity: 0, height: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configShandowContentView(color:  UIColor.lightGray.cgColor, opacity: 0.4, height: 2)
    }
    
    private func configShandowContentView(color: CGColor?, opacity: Float, height: Int){
        contentView.layer.shadowColor = color
        contentView.layer.shadowOpacity = opacity
        contentView.layer.shadowOffset = CGSize(width: 0, height: height)
        contentView.layer.shadowRadius = 0
        contentView.layer.masksToBounds = false
    }
    
    private func setUpViews(){
        let tapGestureCart = UITapGestureRecognizer(target: self, action: #selector(tappedAddToCart(_:)))
        let tapGestureWish = UITapGestureRecognizer(target: self, action: #selector(tappedWishList(_:)))
        addButton.addGestureRecognizer(tapGestureCart)
        wishListButton.addGestureRecognizer(tapGestureWish)
    }
    
    @objc private func tappedAddToCart(_ sender: UITapGestureRecognizer){
        guard let button = sender.view as? UIButton else { return }
        let event = AddToCartCellEvent.addToCartTapped
        button.animate(deep: .small)
        onButtonTap?(event)
    }
    
    @objc private func tappedWishList(_ sender: UITapGestureRecognizer){
        guard let button = sender.view as? UIButton else { return }
        let event = AddToCartCellEvent.addToWishList
        button.animate(deep: .medium)
        onButtonTap?(event)
    }
    
    private func setDefaultImage(imageView: UIImageView){
        imageView.image = UIImage(systemName: "photo")?.withTintColor(.lightGray,renderingMode: .alwaysOriginal)
    }
    
    private func setViews(){
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        [
            productImage,
            nameLabel,
            priceLabel,
            addButton,
            wishListButton,
        ].forEach { contentView.addSubview($0) }
    }
    
    private func layoutViews(){

        productImage.snp.makeConstraints { make in
            make.trailing.leading.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(productImage.snp.bottom).offset(5).priority(.high)
            make.top.lessThanOrEqualTo(productImage.snp.bottom).offset(11).priority(.high)
            make.trailing.equalToSuperview().offset(-13)
            make.leading.equalToSuperview().offset(13)
            make.height.equalTo(15)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4).priority(.high)
            make.trailing.equalToSuperview().offset(-13)
            make.leading.equalToSuperview().offset(13)
            make.bottom.greaterThanOrEqualTo(addButton.snp.top).offset(-5).priority(.high)
            make.bottom.lessThanOrEqualTo(addButton.snp.top).offset(-11).priority(.high)
        }

        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-13)
            make.leading.equalTo(wishListButton.snp.trailing).offset(4)
            make.bottom.equalToSuperview().offset(-13)
            make.height.lessThanOrEqualTo(30)
        }

        wishListButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-13)
            make.leading.equalToSuperview().offset(13)
            make.width.equalTo(addButton.snp.height)
            make.height.lessThanOrEqualTo(30)
        }
    }
}
//MARK: - Configure Cell UI Public Method
extension ProductCell{
    func configCell(descText: String, priceText: Int, image: String?, isLiked: Bool?, isRemoveFavor: Bool){
        removeButtonFavorite(isRemove: isRemoveFavor, isLiked: isLiked)
        nameLabel.text = descText
        priceLabel.text = String(priceText)
        if let image = image {
            setDefaultImage(imageView: productImage)
            productImage.kf.indicatorType = .activity
            productImage.kf.setImage(with: URL(string: image))
        } else {
            setDefaultImage(imageView: productImage)
        }
    }
    
    private func removeButtonFavorite(isRemove: Bool, isLiked: Bool?){
        if isRemove{
            wishListButton.removeFromSuperview()
            addButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(13)
            }
        } else if let isLiked = isLiked{
            let favoriteImage: UIImage? = isLiked ? UIImage(named: "HeartTapped") : UIImage(named: "Heart")
            wishListButton.setBackgroundImage(favoriteImage, for: .normal)
        }
    }
    
    func setImageForWishListButton(isLiked: Bool){
        let favoriteImage: UIImage? = isLiked ? UIImage(named: "HeartTapped") : UIImage(named: "Heart")
        wishListButton.setBackgroundImage(favoriteImage, for: .normal)
    }
}
