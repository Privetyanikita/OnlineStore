//
//  SearchResultHeader.swift
//  OnlineStore
//
//  Created by Polina on 18.04.2024.
//

import UIKit

protocol HeaderSavesSerchesDelegate: AnyObject {
    func cancelButtontapped()
}

final class HeaderSavesSerches: UICollectionReusableView{
    static let resuseID = String(describing: HeaderSavesSerches.self)
    
    weak var delegate: HeaderSavesSerchesDelegate?
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.configLabel(font: Font.getFont(.medium, size: 16), lines: 1, alignment: .left, color: UIColor.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonCancelAll: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Clear all", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = Font.getFont(.medium, size: 12)
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
    
    private func setUpViews(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedCancelButton(_:)))
        buttonCancelAll.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tappedCancelButton(_ sender: UITapGestureRecognizer){
        guard let button = sender.view as? UIButton else { return }
        button.animate(deep: .small)
        delegate?.cancelButtontapped()
    }
    
    private func setViews(){
        [
            headerLabel,
            buttonCancelAll,
        ].forEach { addSubview($0) }
    }
    
    private func layoutViews(){
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(23)
            make.centerY.equalToSuperview()
        }
        
        buttonCancelAll.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-23)
            make.centerY.equalToSuperview()
            make.width.equalTo(47)
            make.height.equalTo(15)
        }
    }
    
    func configureHeader(sectionTitle: String){
        headerLabel.text = sectionTitle
    }
}
