//
//  FBButton.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 21.04.2024.

import UIKit

class FBButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        NSCoder.fatalErrorNotImplemented()
    }
    
    
    convenience init(color: UIColor, title: String, systemImageName: String) {
        self.init(frame: .zero)
        set(color: color, title: title, systemImageName: systemImageName)
    }
    
    
    private func configure() {
        
        configuration              = .filled()
        configuration?.cornerStyle = .capsule
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func set(color: UIColor, title: String, systemImageName: String) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = .white
        configuration?.title               = title
    
        configuration?.image            = UIImage(systemName: systemImageName)
        configuration?.imagePadding     = 6
        configuration?.imagePlacement   = .leading
    }
}
