//
//  SearcResultCellTableViewCell.swift
//  OnlineStore
//
//  Created by Polina on 18.04.2024.
//

import UIKit
import SnapKit

enum CancelCellEvent {
    case delete
}

final class SearchResultCell: UICollectionViewCell {
    static let resuseID = String(describing: SearchResultCell.self)
    var onButtonTap: ((CancelCellEvent) -> Void)?
    
    private let clockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.configImageView(cornerRadius: 0, contentMode: .scaleAspectFill)
        imageView.image = UIImage(systemName: "clock")?.withTintColor(.lightGray,renderingMode: .alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let searchSavesLabel: UILabel = {
        let label = UILabel()
        label.configLabel(font: Font.getFont(.regular, size: 14), lines: 1, alignment: .left, color: UIColor.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.tintColor = .lightGray
        button.setBackgroundImage(UIImage(systemName: "clear")?.withTintColor(.lightGray,renderingMode: .alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setUpViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchSavesLabel.text = nil
    }
    
    private func setUpViews(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedCancelButton(_:)))
        cancelButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tappedCancelButton(_ sender: UITapGestureRecognizer){
        guard let button = sender.view as? UIButton else { return }
        let event = CancelCellEvent.delete
        button.animate(deep: .small)
        onButtonTap?(event)
    }
    
    private func setViews(){
        contentView.backgroundColor = .white
        [
            clockImage,
            searchSavesLabel,
            cancelButton
        ].forEach { contentView.addSubview($0) }
    }
    
    private func layoutViews(){
        clockImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.width.equalTo(18)
        }
        
        searchSavesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.bottom.equalToSuperview().offset(-3)
            make.leading.equalTo(clockImage.snp.trailing).offset(14)
            make.trailing.equalTo(cancelButton.snp.leading).offset(-14)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.width.equalTo(20)
        }
    }
}

//MARK: - Configure Cell UI Public Method
extension SearchResultCell{
    func configCell(savesSearches: String){
        searchSavesLabel.text = savesSearches
    }
}
