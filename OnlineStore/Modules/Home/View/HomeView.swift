//
//  HomeView.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

protocol HomeViewDelegateProtocol: AnyObject{
    func addToCart(item: Product)
}

final class HomeView: UIView{
    // MARK: - Public Properties
    var selectedCategory: IndexPath = .init()
    
    // MARK: - Private Properties
    private weak var headerDelegate: HeaderProductsDelegate?
    private weak var delegate: HomeViewDelegateProtocol?
    private weak var searchBarDelegate: UISearchBarDelegate?
    private var diffableDataSource: UICollectionViewDiffableDataSource<SectionModel, ItemModel>?
    private var sections: [SectionModel] = SectionModel.allCases
    
    private let collectionView: HomeCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = HomeCollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    init(){
        super.init(frame: .zero)
        setViews()
        layoutViews()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - ConfigDiffableDataSource
private extension HomeView{
    func setupDataSource(){
        diffableDataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier{
            case .searchBar:
                let cell = collectionView.dequeueReusableCell(type: SearchbarCell.self,
                                                              for: indexPath)
                cell.setUpSearchBarDelegate(delegateVC: self.searchBarDelegate)
                return cell
            case .categories(let category):
                let cell = collectionView.dequeueReusableCell(type: CategoriesCell.self,
                                                              for: indexPath)
                cell.configCell(categoryLabelText: category.name, image: category.image)
                self.selectedCategory == indexPath ?  cell.setSelectedBorder() : cell.setDefaultBorder()
                return cell
            case .products(let product):
                let cell = collectionView.dequeueReusableCell(type: ProductCell.self,
                                                              for: indexPath)
                cell.configCell(nameTitle: product.title, priceTitle: product.price, images: product.images, isLiked: nil, isRemoveFavor: true)
                cell.onButtonTap = { event in
                    switch event{
                    case .addToCartTapped:
                        self.delegate?.addToCart(item: product)
                    case .addToWishList:
                        break
                    }
                }
                return cell
            }
        })
        
        diffableDataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let header = collectionView.reuseSupplementaryView(ofKind: kind, type: HeaderProductsView.self, for: indexPath)
            let section = self.sections[indexPath.section]
            header.configureHeader(sectionTitle: section.title, type: .home)
            header.delegate = self.headerDelegate
            return header
        }
    }
}

// MARK: - LayOutViews
private extension HomeView{
    func setViews(){
        [
            collectionView,
        ].forEach { addSubview($0) }
    }
    
    func layoutViews(){
        backgroundColor = .white
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(62)
            make.bottom.equalToSuperview()
        }
    }
}
// MARK: - Public Methods
extension HomeView{
    func setUPDelegates(delegateCollectionView: UICollectionViewDelegate,
                        headerDelegate: HeaderProductsDelegate,
                        searchBarDelegate: UISearchBarDelegate,
                        delegate: HomeViewDelegateProtocol)
    {
        collectionView.delegate = delegateCollectionView
        self.headerDelegate = headerDelegate
        self.searchBarDelegate = searchBarDelegate
        self.delegate = delegate
    }
    
    func getItem(index: IndexPath) -> ItemModel?{
       return diffableDataSource?.itemIdentifier(for: index)
    }
    
    func applyDiffableSnapShot(products: [ItemModel], categories: [ItemModel]){
        DispatchQueue.main.async { [self] in
            var snapShot = NSDiffableDataSourceSnapshot<SectionModel, ItemModel>()
            snapShot.appendSections([.searchbar, .categories, .products])
            snapShot.appendItems([.searchBar], toSection: .searchbar)
            snapShot.appendItems(products, toSection: .products)
            snapShot.appendItems(categories, toSection: .categories)
            diffableDataSource?.apply(snapShot, animatingDifferences: true)
        }
    }
}
