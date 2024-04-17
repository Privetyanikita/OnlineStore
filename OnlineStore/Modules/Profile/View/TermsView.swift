//
//  TermsView.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 16.04.2024.
//

import UIKit
import SnapKit

class TermsView: UIView {
    
    var onCloseTap: (() -> Void)?
    
    private let termsLabel: UILabel = {
        let termsLabel = UILabel()
        termsLabel.font = .systemFont(ofSize: 24, weight: .regular)
        termsLabel.textColor = .darkGray
        termsLabel.textAlignment = .left
        termsLabel.text = "Terms & Conditions"
        
        return termsLabel
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .close)
        closeButton.tintColor = .darkGray
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        return closeButton
    }()

    private let termsText: UITextView = {
        let termsText = UITextView()
        termsText.isEditable = false
        termsText.font = .systemFont(ofSize: 14, weight: .regular)
        termsText.textColor = .darkGray
        termsText.textAlignment = .justified
        
        return termsText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(termsLabel)
        addSubview(closeButton)
        addSubview(termsText)
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        termsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(32)
        }
        
        closeButton.snp.makeConstraints { make in
            make.trailing.centerY.equalTo(termsLabel)
        }
        
        termsText.snp.makeConstraints { make in
            make.leading.trailing.equalTo(termsLabel)
            make.top.equalTo(termsLabel.snp.bottom).offset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(6)
        }
        
        termsText.text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin viverra, nisi eu dignissim molestie, mi nisl eleifend massa, cursus lacinia mi arcu a sapien. Sed quis felis vulputate, rhoncus odio sit amet, malesuada augue. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Donec nibh massa, finibus sed risus porta, lacinia efficitur tortor. Aenean molestie tortor in massa rutrum, suscipit viverra mauris eleifend. Maecenas eu neque non massa imperdiet congue et eu dui. Nulla viverra, massa ac volutpat auctor, erat mi malesuada sapien, vel tristique felis risus sed metus. In ac accumsan arcu.
        
        Vivamus eget posuere magna, a fermentum ante. Sed in purus at risus molestie dapibus et vel dolor. Proin lobortis risus et neque viverra, ut mattis tortor tempor. Integer et ultricies nunc. Fusce sit amet lectus vehicula, convallis diam quis, sagittis velit. Praesent rhoncus, urna a congue hendrerit, massa ante malesuada quam, commodo dapibus lacus diam et libero. Curabitur massa tortor, lobortis sed massa id, porta lacinia ante. Praesent imperdiet, nibh id volutpat tincidunt, lectus dui mattis nisl, nec porta metus tortor nec ex. In hac habitasse platea dictumst. Vestibulum vel nunc id nulla dictum fermentum sit amet ut dolor.

        Quisque eu libero sed sem feugiat ultrices ac non ex. Integer eget turpis eget lacus pulvinar hendrerit. Nulla facilisi. Donec sit amet dolor in libero faucibus ultricies sed ac dui. Nunc at ex gravida, dapibus ante sit amet, egestas nisi. Duis vel congue libero. Aliquam congue non dui a ullamcorper. Fusce semper blandit metus sit amet gravida. Nulla facilisi.

        Aenean placerat lectus felis, in dignissim mi mattis id. Integer accumsan euismod diam consectetur fermentum. Etiam luctus sem vehicula, efficitur massa sit amet, pellentesque augue. Duis gravida velit faucibus euismod auctor. Mauris sed purus a nisl mollis bibendum eget ac turpis. Cras luctus, lorem at porta iaculis, quam tortor efficitur velit, quis sollicitudin ante risus vitae risus. Praesent malesuada venenatis erat, varius venenatis justo sollicitudin non. Aliquam imperdiet consequat sapien, ac maximus ligula vestibulum eget. Donec ornare sit amet lacus vitae laoreet.

        Praesent vitae mauris in nisi eleifend condimentum. Phasellus finibus ipsum ultricies neque cursus, vel semper neque tempor. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer varius nibh nisi, vel cursus risus mollis in. Praesent purus libero, porta sed nunc vel, tempus finibus augue. Praesent tempus vestibulum feugiat. Praesent ac metus pulvinar ante dignissim gravida. Ut sit amet tempor arcu. Sed vulputate eget augue ut gravida. Quisque non porttitor nibh. Maecenas ultricies euismod lacus, non aliquam nibh ultrices eu. Maecenas elementum, justo a luctus bibendum, lorem neque ullamcorper odio, sit amet tincidunt sapien arcu in lectus. In orci purus, egestas ac diam quis, dignissim vestibulum justo. Cras eget justo eget ante lobortis mollis in a massa. In a erat eget magna porta rhoncus et ut diam.
        """
    }
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        onCloseTap?()
    }
}
