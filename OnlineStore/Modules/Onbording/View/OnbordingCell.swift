//
//  OnbordingCell.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//

import UIKit
import SnapKit

class OnbordingCell: UICollectionViewCell {
    static let resuseID = String(describing: OnbordingCell.self)
    
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
        imageView.configImageView(cornerRadius: 30, contentMode: .scaleAspectFill)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageCart.layoutIfNeeded()
        clip(imageView: imageCart, withRightBottomOffset: 50, cornerRadius: 30)
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
extension OnbordingCell {
    func configCell(titleText: String, descriptionText: String, image: UIImage?){
        titleLabel.text = titleText
        subTitleLabel.text = descriptionText
        imageCart.image = image
    }
}


extension OnbordingCell {
    
    private func clip(imageView: UIView, withRightBottomOffset: CGFloat, cornerRadius: CGFloat) {
        let path = UIBezierPath()

        path.move(to: .init(x: 0, y: 0))
        
        path.addLine(to: .init(x: imageView.bounds.size.width, y: 0))
        
        path.addLine(to: .init(x: imageView.bounds.size.width, y: (imageView.bounds.size.height - withRightBottomOffset) - cornerRadius))
        
        let controlPoint1 = CGPoint(
            x: imageView.bounds.size.width,
            y: (imageView.bounds.size.height - withRightBottomOffset) + (cornerRadius / 2))
        
        let controlPoint2 = CGPoint(
            x: imageView.bounds.size.width,
            y: (imageView.bounds.size.height - withRightBottomOffset) + (cornerRadius * 0.75))
        
        path.addCurve(to:
                .init(x: imageView.bounds.size.width - cornerRadius, y: (imageView.bounds.size.height - withRightBottomOffset) + cornerRadius),
                      controlPoint1: controlPoint1,
                      controlPoint2: controlPoint2)

        path.addLine(to: .init(x: cornerRadius, y: imageView.bounds.size.height))

        let controlPoint3 = CGPoint(
            x: 0 + (cornerRadius / 2),
            y: imageView.bounds.size.height)
        
        let controlPoint4 = CGPoint(
            x: 0,
            y: imageView.bounds.size.height - (cornerRadius / 2))
        
        path.addCurve(to:
                .init(x: 0, y: imageView.bounds.size.height - cornerRadius),
                      controlPoint1: controlPoint3,
                      controlPoint2: controlPoint4)
        
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor
        imageView.layer.mask = shapeLayer
    }
}
