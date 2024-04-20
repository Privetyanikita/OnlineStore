//
//  DetailCollectionViewCell.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit
import SnapKit

final class DetailCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: DetailCollectionViewCell.self)
    
    private let productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        addSubview(productImageView)
        
        productImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func configure(_ color: UIColor) {
        //TODO: жду не моковую модель, пока заглушка из цвета
        backgroundColor = color
    }
    
    
}
