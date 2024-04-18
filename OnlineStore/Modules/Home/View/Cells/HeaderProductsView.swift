//
//  Hesder.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//

import UIKit
import SnapKit

enum HeaderType{
    case home
    case searchResult
}

protocol HeaderProductsViewDelegate {
    func changeHeaderTitle(serchWord: String)
}

protocol HeaderProductsDelegate: AnyObject {
    func choseFiltration(filterType: FilterModel)
}

class HeaderProductsView: UICollectionReusableView {
    static let resuseID = String(describing: HeaderProductsView.self)
    
    weak var delegate: HeaderProductsDelegate?
    
    private let filters: [FilterModel] = FilterModel.allCases
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.configLabel(font: Font.getFont(.medium, size: 14), lines: 1, alignment: .left, color: UIColor.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonFilter: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "CustomLightGrey")?.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let filterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.configImageView(cornerRadius: 0, contentMode: .scaleAspectFill)
        imageView.image = UIImage(named: "Filter")?.withTintColor(.black,renderingMode: .alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let buttonTextlabel: UILabel = {
        let label = UILabel()
        label.configLabel(font: Font.getFont(.regular, size: 12), lines: 1, alignment: .center, color: UIColor.black)
        label.text = "Filter"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        backgroundColor = .white
        configMenu(button: buttonFilter)
    }
    
    private func configMenu( button: UIButton){
        let menu = UIMenu(title: "Filters",children: createMenuChildren(buttonType: button))
        button.showsMenuAsPrimaryAction = true
        button.menu = menu
    }
    
    func createMenuChildren(buttonType: UIButton) -> [UIAction]{
        return filters.map { filter in
            UIAction(title: filter.typeFilterLabel, handler: { [unowned self] action in
                delegate?.choseFiltration(filterType: filter)
            })
        }
    }
    
    private func setViews(){
        [
            buttonFilter,
            headerLabel,
        ].forEach { addSubview($0) }
        buttonFilter.addSubview(buttonTextlabel)
        buttonFilter.addSubview(filterImage)
    }
    
    private func layoutViews(){
        
        buttonTextlabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
        
        filterImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        buttonFilter.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-40)
            make.centerY.equalToSuperview()
            make.width.equalTo(78)
            make.height.equalTo(27)
        }
    }
    
    func configureHeader(sectionTitle: String, type: HeaderType){
        headerLabel.text = sectionTitle
        switch type{
        case .home:
            break
        case .searchResult:
            headerLabel.textColor = .lightGray
            headerLabel.font = Font.getFont(.regular, size: 14)
        }
    }
}
// MARK: - HeaderProductsViewDelegate
extension HeaderProductsView: HeaderProductsViewDelegate{
    func changeHeaderTitle(serchWord: String) {
        headerLabel.text = "Search result for " + serchWord
    }
}
