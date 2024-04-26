//
//  UITableViewCell + Ext.swift
//  OnlineStore
//
//  Created by Polina on 26.04.2024.
//

import UIKit
// MARK: - LoadImage
extension UITableViewCell{
    func loadImageTableViewCell(url: String, imageView: UIImageView){
        if url != "https://placeimg.com/640/480/any" {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: url)) { result in
                switch result{
                case .success(_):
                    break
                case .failure(_):
                    self.setDefaultImage(imageView: imageView)
                }
            }
        } else {
            setDefaultImage(imageView: imageView)
        }

    }
    
    private func setDefaultImage(imageView: UIImageView){
        imageView.image = UIImage(systemName: "photo")?.withTintColor(.lightGray,renderingMode: .alwaysOriginal)
    }
}
