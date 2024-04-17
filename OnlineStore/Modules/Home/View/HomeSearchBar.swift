//
//  MainSearchBar.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//

import UIKit
final class HomeSearchBar: UISearchBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLeftRightImages()
        setUpSearchTextField()
        setUpAppearence()
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpSearchTextField() {
        searchTextField.font = Font.getFont(.regular, size: 13)
        searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        searchTextField.textColor = .gray
        searchTextField.layer.cornerRadius = 12
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchTextField.backgroundColor = .white//.lightGray.withAlphaComponent(0.2)
        let attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchTextField.attributedPlaceholder = attributedPlaceholder
    }
    
    private func setUpLeftRightImages(){
        let image = UIImage(systemName: "magnifyingglass")?.withTintColor(UIColor.lightGray, renderingMode: .alwaysOriginal)
        let clearImage = UIImage(systemName: "xmark.circle.fill")?.withTintColor(UIColor.lightGray, renderingMode: .alwaysOriginal)
        setImage(image, for: .search, state: .normal)
        setImage(clearImage, for: .clear, state: .normal)
    }

    private func setUpAppearence() {
        let backgroundImage = UIImage.imageWithColor(color: .white)
        setBackgroundImage(backgroundImage, for: .any, barMetrics: .default)
        tintColor = UIColor.lightGray
        layer.cornerRadius = 12.0
        clipsToBounds = true
    }
}
