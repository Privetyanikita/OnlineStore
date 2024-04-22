//
//  SerchView.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

protocol SearchViewDelegateProtocol: AnyObject{
    func addToCart(item: ProductsModel)
    func deleteOneHistorySearch(id: UUID)
}

final class SearchView: UIView{
    // MARK: - Public Properties
    var headerDelegate: HeaderProductsViewDelegate?
    var searchWord: String = ""
    
    // MARK: - Private Properties
    private weak var delegate: SearchViewDelegateProtocol?
    private weak var headerDelegateSaves: HeaderSavesSerchesDelegate?
    private weak var headerDelegateResult: HeaderProductsDelegate?
    
    private var diffableDataSourceResult: UICollectionViewDiffableDataSource<SectionSearchModel, ProductsModel>?
    private var diffableDataSourceSaves: UICollectionViewDiffableDataSource<SectionsSavesModel, SavesSerchesModel>?
    
    private let sectionsSearchResult: [SectionSearchModel] = SectionSearchModel.allCases
    private let sectionsSavesReserches: [SectionsSavesModel] =  SectionsSavesModel.allCases
    
    private let collectionViewSearchResult: SearchResultCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = SearchResultCollectionView(frame: .zero, collectionViewLayout: layout, shouldCreateHeader: true, groupSpacing: 0)
        view.tag = 0
        return view
    }()
    
    private let collectionViewSerchSaves: SavesSearchesCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = SavesSearchesCollectionView(frame: .zero, collectionViewLayout: layout)
        view.isHidden = true
        view.tag = 1
        return view
    }()
    
    init(){
        super.init(frame: .zero)
        setViews()
        layoutViews()
        setupDataSourceResult()
        setupDataSourceSaves()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LayOut
extension SearchView{
    private func setViews(){
        [
            collectionViewSearchResult,
            collectionViewSerchSaves,
        ].forEach { addSubview($0) }
    }
    
    private func layoutViews(){
        backgroundColor = .white
        collectionViewSearchResult.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(62)
            make.bottom.equalToSuperview()
        }
        
        collectionViewSerchSaves.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(62)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - SetUpDiffableDataSource
extension SearchView{
    private func setupDataSourceResult(){
        diffableDataSourceResult = .init(collectionView: collectionViewSearchResult, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(type: ProductCell.self,
                                                          for: indexPath)
            cell.configCell(descText: itemIdentifier.description, priceText: itemIdentifier.price, image: itemIdentifier.image, isLiked: nil, isRemoveFavor: true)
            cell.onButtonTap = { event in
                switch event{
                case .addToCartTapped:
                    self.delegate?.addToCart(item: itemIdentifier)   //добавить в корзину
                case .addToWishList:
                    break
                }
            }
            return cell
        })
        
        diffableDataSourceResult?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderProductsView.resuseID, for: indexPath) as? HeaderProductsView else { return nil }
            let section = self.sectionsSearchResult[indexPath.section]
            header.configureHeader(sectionTitle: section.title + self.searchWord, type: .searchResult)
            header.delegate = self.headerDelegateResult
            self.headerDelegate = header
            return header
        }
    }
    
    private func setupDataSourceSaves(){
        diffableDataSourceSaves = .init(collectionView: collectionViewSerchSaves, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(type: SearchResultCell.self,
                                                          for: indexPath)
            cell.configCell(savesSearches: itemIdentifier.saveSearch)
            cell.onButtonTap = { event in
                switch event{
                case .delete:
                    self.delegate?.deleteOneHistorySearch(id: itemIdentifier.id)
                }
            }
            return cell
        })
        
        diffableDataSourceSaves?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSavesSerches.resuseID, for: indexPath) as? HeaderSavesSerches else { return nil }
            let section = self.sectionsSavesReserches[indexPath.section]
            header.configureHeader(sectionTitle: section.title)
            header.delegate = self.headerDelegateSaves
            return header
        }
    }
}
// MARK: - Public Methods
extension SearchView{
    func setUPDelegates(delegeteResult: UICollectionViewDelegate,
                        delegateSaves: UICollectionViewDelegate,
                        headerDelegateSaves: HeaderSavesSerchesDelegate,
                        headerDelegateResult: HeaderProductsDelegate,
                        delegate: SearchViewDelegateProtocol)
    {
        collectionViewSearchResult.delegate = delegeteResult
        collectionViewSerchSaves.delegate = delegateSaves
        self.headerDelegateSaves = headerDelegateSaves
        self.headerDelegateResult = headerDelegateResult
        self.delegate = delegate
    }
    
    func hideCollectionView(isHideSavesCollection: Bool, isHideResultCollection: Bool){
        collectionViewSerchSaves.isHidden = isHideSavesCollection
        collectionViewSearchResult.isHidden = isHideResultCollection
    }
    
    func getItemSerch(index: IndexPath) -> SavesSerchesModel?{
        return diffableDataSourceSaves?.itemIdentifier(for: index)
    }
    
    func getItemResult(index: IndexPath)-> ProductsModel?{
        return diffableDataSourceResult?.itemIdentifier(for: index)
    }
    
    func applySnapShotResults(products: [ProductsModel]){
        DispatchQueue.main.async { [self] in
            var snapShot = NSDiffableDataSourceSnapshot<SectionSearchModel, ProductsModel>()
            snapShot.appendSections([.searchResult])
            snapShot.appendItems(products, toSection: .searchResult)
            diffableDataSourceResult?.apply(snapShot, animatingDifferences: true)
        }
    }
    
    func applySnapShotSaves(saveSearches: [SavesSerchesModel]){
        DispatchQueue.main.async { [self] in
            var snapShot = NSDiffableDataSourceSnapshot<SectionsSavesModel, SavesSerchesModel>()
            snapShot.appendSections([.savesSerches])
            snapShot.appendItems(saveSearches, toSection: .savesSerches)
            diffableDataSourceSaves?.apply(snapShot, animatingDifferences: true)
        }
    }
}
