//
//  OnbordingCell.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//

import UIKit
import SnapKit

class OnbordingCell: UICollectionViewCell {
    static let resuseID = "OnbordingCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configLabel(font: Font.getFont(.extraBold, size: 28), lines: 2, alignment: .left, color: .black)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.configLabel(font: Font.getFont(.regular, size: 18), lines: 3, alignment: .left, color: .lightGray)
        return label
    }()
    
    private let imageCart: UIImageView = {
        let imageView = UIImageView()
        imageView.configImageView(cornerRadius: 12, contentMode: .scaleAspectFill)
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
        titleLabel.text = nil
        subTitleLabel.text = nil
        imageCart.image = nil
    }
    
    private func setViews(){
        [
            titleLabel,
            subTitleLabel,
            imageCart,
        ].forEach { contentView.addSubview($0) }
    }
    
    private func layoutViews(){
        imageCart.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(450)
         }

         titleLabel.snp.makeConstraints { make in
             make.top.equalTo(imageCart.snp.bottom).offset(24)
             make.leading.equalTo(contentView.snp.leading)
             make.trailing.equalTo(contentView.snp.trailing).offset(-60)
         }

         subTitleLabel.snp.makeConstraints { make in
             make.top.equalTo(titleLabel.snp.bottom).offset(24)
             make.leading.equalTo(contentView.snp.leading)
             make.trailing.equalTo(contentView.snp.trailing).offset(-60)
         }
    }
}

//MARK: - Configure Cell UI Public Method
extension OnbordingCell{
    func configCell(titleText: String, descriptionText: String, image: UIImage?){
        titleLabel.text = titleText
        subTitleLabel.text = descriptionText
        imageCart.image = image
    }
}
