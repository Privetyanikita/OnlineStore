//
//  BackButton.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 16.04.2024.
//

import UIKit

final class BackButton: UIButton {

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func setup() {
        setImage(Image.arrowLeft, for: .normal)
        self.tintColor = .systemGray
        self.imageView?.contentMode = .scaleToFill
    }

}
