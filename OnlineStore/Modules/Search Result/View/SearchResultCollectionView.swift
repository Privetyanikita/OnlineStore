//
//  SearchResultCollectionView.swift
//  OnlineStore
//
//  Created by Polina on 18.04.2024.
//

import UIKit

final class SearchResultCollectionView: UICollectionView{
    private var sections: [SectionSearchModel] =  SectionSearchModel.allCases
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configCollectionView()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configCollectionView(){
        backgroundColor = .none
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        bounces = false
        collectionViewLayout = createLayout()
    }
    
    private func registerCells(){
        register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.resuseID)
        register(HeaderProductsView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderProductsView.resuseID)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout{
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }
            let section = sections[sectionIndex]
            switch section{
            case .searchResult:
                return createProductsSection()
            }
        }
    }
    
    private func createProductsSection() -> NSCollectionLayoutSection{
        let item = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), spacing: 4)
        let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.3), subitems: [item])
        let section = CompositionalLayout.createSection(group: group, scrollBehavior: .none, groupSpacing: 0, leading: 12, trailing: 12, top: 12, bottom: 8,  supplementary: [createHeader()])
        return section
    }
    
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        .init(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}

