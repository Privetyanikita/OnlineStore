//
//  SearchBarCell.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//


import UIKit

class SearchbarCell: UICollectionViewCell {
    static let resuseID = String(describing: SearchbarCell.self)
    
    private let searchBar = HomeSearchBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViews(){
        contentView.addSubview(searchBar)
    }
    
    private func layoutViews(){
        searchBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - Configure Cell UI Public Method
extension SearchbarCell{
    func setUpSearchBarDelegate(delegateVC: UISearchBarDelegate?){
        searchBar.delegate = delegateVC
    }
}
