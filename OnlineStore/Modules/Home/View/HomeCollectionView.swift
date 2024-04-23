//
//  MainCollectionView.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//


import UIKit

final class HomeCollectionView: UICollectionView{
    private var sections: [SectionModel] =  SectionModel.allCases
    
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
        register(SearchbarCell.self)
        register(CategoriesCell.self)
        register(ProductCell.self)
        registerHeader(supplementaryViewType: HeaderProductsView.self)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout{
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }
            let section = sections[sectionIndex]
            
            switch section{
            case .categories:
                return createCategoriesSection()
            case .products:
                return createProductsSection()
            case .searchbar:
                return createSearchBar()
            }
        }
    }
    
    private func createSearchBar() -> NSCollectionLayoutSection{
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
        let group = CompositionalLayout.createGroup(alignment: .horizontal, width:  .fractionalWidth(1), height: .absolute(40), subitems: [item])
        let section = CompositionalLayout.createSection(group: group, scrollBehavior: .none, groupSpacing: 0, leading: 8, trailing: 8, top: 0, bottom: 0, supplementary: nil)
        return section
    }
    
    private func createCategoriesSection() -> NSCollectionLayoutSection{
        let item = CompositionalLayout.createItem(width: .fractionalWidth(0.2), height: .fractionalHeight(1), spacing: 4)
        let group = CompositionalLayout.createGroup(alignment: .horizontal, width:  .fractionalWidth(1), height: .fractionalHeight(0.1), subitems: [item])
        let section = CompositionalLayout.createSection(group: group, scrollBehavior: .none, groupSpacing: 4, leading: 12, trailing: 12, top: 24, bottom: 14, supplementary: nil)
        return section
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
