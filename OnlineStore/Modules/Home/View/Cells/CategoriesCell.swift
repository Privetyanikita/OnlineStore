//
//  CategoriesCell.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//

import UIKit
import Kingfisher

class CategoriesCell: UICollectionViewCell {
    static let resuseID = String(describing: CategoriesCell.self)
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.configLabel(font: Font.getFont(.regular, size: 12), lines: 1, alignment: .center, color: UIColor.lightGray)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.configImageView(cornerRadius: 4, contentMode: .scaleAspectFill)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryLabel.text = nil
        categoryImage.image = nil
    }
            
    private func setViews(){
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = .none
        contentView.addSubview(categoryImage)
        contentView.addSubview(categoryLabel)
    }
    
    private func setDefaultImage(imageView: UIImageView){
        imageView.image = UIImage(systemName: "photo")?.withTintColor(.lightGray,renderingMode: .alwaysOriginal)
    }
    
    private func layoutViews(){
        categoryImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
            make.bottom.equalTo(categoryLabel.snp.top).offset(-6)
        }
        categoryLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-2)
            make.leading.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
            make.height.equalTo(12)
        }
    }
}

//MARK: - Configure Cell UI Public Method
extension CategoriesCell{
    func configCell(categoryLabelText: String, image: String?){
        categoryLabel.text = categoryLabelText.capitalized
        setDefaultImage(imageView: categoryImage)
        if image == "All"{
            categoryImage.image = UIImage(named: "allCategory")
            categoryLabel.text = ""
        } else if let image = image{
            categoryImage.kf.indicatorType = .activity
            categoryImage.kf.setImage(with: URL(string: image))
        }
    }
    
    func setDefaultBorder(){
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = .none
    }
    
    func setSelectedBorder(){
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor(named: "CustomGreen")?.cgColor
    }
}
