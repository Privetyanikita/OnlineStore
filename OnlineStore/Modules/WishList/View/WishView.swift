//
//  WishView.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

protocol WishViewDelegateProtocol: AnyObject{
    func addToCart(item: Product)
    func deleteFromWishList(item: Product)
}

final class WishView: UIView{
    
    // MARK: - Private Properties
    private weak var delegate: WishViewDelegateProtocol?
    private weak var delegateWishList: UICollectionViewDelegate?
    
    private var diffableDataSourceWishList: UICollectionViewDiffableDataSource<SectionSearchModel, Product>?
    
    private let sectionsWishList: [SectionSearchModel] = SectionSearchModel.allCases
    
    private let collectionViewWishList: SearchResultCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = SearchResultCollectionView(frame: .zero, collectionViewLayout: layout, shouldCreateHeader: false, groupSpacing: 31)
        return view
    }()
    
    init(){
        super.init(frame: .zero)
        setViews()
        layoutViews()
        setupDataSourceWishList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LayOut
extension WishView{
    private func setViews(){
        [
            collectionViewWishList
        ].forEach { addSubview($0) }
    }
    
    private func layoutViews(){
        backgroundColor = .white
        collectionViewWishList.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(62)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - SetUpDiffableDataSource
extension WishView{
    private func setupDataSourceWishList(){
        diffableDataSourceWishList = .init(collectionView: collectionViewWishList, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(type: ProductCell.self,
                                                          for: indexPath)
            cell.configCell(nameTitle: itemIdentifier.title, priceTitle: itemIdentifier.price, images: itemIdentifier.images, isLiked: true,  isRemoveFavor: false) // заменить потом на значение с модели isLiked
            cell.onButtonTap = { event in
                switch event{
                case .addToCartTapped:
                    self.delegate?.addToCart(item: itemIdentifier)   //добавить в корзину
                case .addToWishList:
                    self.delegate?.deleteFromWishList(item: itemIdentifier) //удалить из избранного
                }
            }
            return cell
        })
    }
}
// MARK: - Public Methods
extension WishView{
    func setUPDelegates(delegeteWishList: UICollectionViewDelegate,
                        delegate: WishViewDelegateProtocol)
    {
        collectionViewWishList.delegate = delegeteWishList
        self.delegate = delegate
    }
    
    func getItemWishList(index: IndexPath)-> Product?{
        return diffableDataSourceWishList?.itemIdentifier(for: index)
    }
    
    func applySnapShotWishList(products: [Product]){
        DispatchQueue.main.async { [self] in
            var snapShot = NSDiffableDataSourceSnapshot<SectionSearchModel, Product>()
            snapShot.appendSections([.searchResult])
            snapShot.appendItems(products, toSection: .searchResult)
            diffableDataSourceWishList?.apply(snapShot, animatingDifferences: true)
        }
    }
}
