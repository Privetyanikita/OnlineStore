//
//  HomeViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit
import SnapKit

class HomeViewController: BaseViewController {
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<SectionModel, ItemModel>?
    
    private var products: [ProductsModel] = [
        .init(id: 1, image: "https://i.imgur.com/ZANVnHE.jpeg", description: "Aello World", price: 100, isLiked: false),
        .init(id: 2, image: "https://placeimg.com/640/480/any", description: "Cello World", price: 300, isLiked: false),
        .init(id: 3, image: "https://media.istockphoto.com/id/1380361370/photo/decorative-banana-plant-in-concrete-vase-isolated-on-white-background.jpg?s=612x612&w=0&k=20&c=eYADMQ9dXTz1mggdfn_exN2gY61aH4fJz1lfMomv6o4=", description: "Bello World", price: 400, isLiked: false),
        .init(id: 4, image: "https://api.escuelajs.co", description: "Kello World", price: 200, isLiked: false),
        .init(id: 5, image: "https://i.imgur.com/Qphac99.jpeg", description: "Pello World", price: 500, isLiked: false),
        .init(id: 6, image: "https://i.imgur.com/ZANVnHE.jpeg", description: "Lello World", price: 600, isLiked: false),
        .init(id: 7, image: "https://i.imgur.com/ZANVnHE.jpeg", description: "Aello World", price: 100, isLiked: false),
        .init(id: 8, image: "https://i.imgur.com/ZANVnHE.jpeg", description: "Hello World", price: 200, isLiked: false),
        .init(id: 9, image: "https://i.imgur.com/ZANVnHE.jpeg", description: "Hello World", price: 300, isLiked: false),
        .init(id: 10, image: "https://i.imgur.com/ZANVnHE.jpeg", description: "Hello World", price: 400, isLiked: false),
        .init(id: 11, image: "https://i.imgur.com/ZANVnHE.jpeg", description: "Hello World", price: 500, isLiked: false),
        .init(id: 12, image: "https://i.imgur.com/ZANVnHE.jpeg", description: "Hello World", price: 600, isLiked: false),
    ]
    
    private var categories: [CategoriesModel] = [
        .init(id: 1, name: "Clothes", image: "https://i.imgur.com/QkIa5tT.jpeg"),
        .init(id: 2, name: "Toys", image: "https://i.imgur.com/QkIa5tT.jpeg"),
        .init(id: 3, name: "Electronocs", image: "https://i.imgur.com/QkIa5tT.jpeg"),
        .init(id: 4, name: "School", image: "https://i.imgur.com/QkIa5tT.jpeg"),
        .init(id: 5, name: "All", image: "https://i.imgur.com/QkIa5tT.jpeg"),
        .init(id: 6, name: "Mock1", image: "https://i.imgur.com/QkIa5tT.jpeg"),
        .init(id: 7, name: "Mock1", image: "https://i.imgur.com/QkIa5tT.jpeg"),
        .init(id: 8, name: "Mock1", image: "https://i.imgur.com/QkIa5tT.jpeg"),
        .init(id: 9, name: "Mock1", image: "https://i.imgur.com/QkIa5tT.jpeg"),
    ]
    
    private var categArray: [ItemModel] = []
    private var prodArray: [ItemModel] = []
    private var sections: [SectionModel] = SectionModel.allCases
    
    private var selectedCategory: IndexPath = .init()
    
    
    private let collectionView: HomeCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = HomeCollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
        CustomNavigationBarConfiguration(
            title: Titles.title,
            withSearchTextField: false,
            isSetupBackButton: false,
            rightButtons: [.shoppingCart, .notification])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hookUpNavBarButtons()
        setViews()
        layoutViews()
        setUPDelegates()
        setupDataSource()
        prodArray = products.map { .products($0)}
        categArray = categories.prefix(5).map { .categories($0)}
        applyDiffableSnapShot()
    }
    
    func setUPDelegates(){
        collectionView.delegate = self
    }
    
}
// MARK: - SetUP NavBar
private extension HomeViewController{
    func hookUpNavBarButtons() {
        customNavigationBar.notificationButton.addTarget(self, action: #selector(notificationsButtonTapped), for: .touchUpInside)
        customNavigationBar.shoppingCartButton.addTarget(self, action: #selector(shoppingCartButtonTapped), for: .touchUpInside)
    }
    
    @objc func notificationsButtonTapped() {
        print(">> NOTIFICATIONS BTN tapped")
    }
    
    @objc func shoppingCartButtonTapped() {
        print(">> SHOPPING CART BTN tapped")
    }
}
// MARK: - ConfigDiffableDataSource
extension HomeViewController{
    private func setupDataSource(){
        diffableDataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier{
            case .searchBar:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchbarCell.resuseID, for: indexPath) as? SearchbarCell else { return UICollectionViewCell() }
                cell.setUpSearchBarDelegate(delegateVC: self)
                return cell
            case .categories(let categoriesModel):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCell.resuseID, for: indexPath) as? CategoriesCell else { return UICollectionViewCell() }
                cell.configCell(categoryLabelText: categoriesModel.name, image: categoriesModel.image)
                self.selectedCategory == indexPath ?  cell.setSelectedBorder() : cell.setDefaultBorder()
                return cell
            case .products(let productModel):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.resuseID, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
                cell.configCell(descText: productModel.description, priceText: productModel.price, image: productModel.image, isLiked: nil, isRemoveFavor: true)
                cell.onButtonTap = { event in
                    switch event{
                    case .addToCartTapped:
                        print(productModel.id) //добавить в корзину
                    case .addToWishList:
                        break
                    }
                }
                return cell
            }
        })
        
        diffableDataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderProductsView.resuseID, for: indexPath) as? HeaderProductsView else { return nil }
            let section = self.sections[indexPath.section]
            header.configureHeader(sectionTitle: section.title, type: .home)
            header.delegate = self
            return header
        }
    }
    
    private func applyDiffableSnapShot(){
        DispatchQueue.main.async { [self] in
            var snapShot = NSDiffableDataSourceSnapshot<SectionModel, ItemModel>()
            snapShot.appendSections([.searchbar, .categories, .products])
            snapShot.appendItems([.searchBar], toSection: .searchbar)
            snapShot.appendItems(prodArray, toSection: .products)
            snapShot.appendItems(categArray, toSection: .categories)
            diffableDataSource?.apply(snapShot, animatingDifferences: true)
        }
    }
}
// MARK: - Private Methods
private extension HomeViewController{
    func updateProductsSection(categoryNumber: Int){
        if categoryNumber == 4{
            categArray = (categArray.count > 5) ? categories.prefix(5).map { .categories($0)} : categories.map { .categories($0)}
            applyDiffableSnapShot()
        } else {
            //запрос в сеть
        }
    }
    
    func selectionCategory(selectedIndexpath: IndexPath){
        if selectedIndexpath.item != 4{
            let cell = collectionView.cellForItem(at: selectedIndexpath) as? CategoriesCell
            let previousCell = collectionView.cellForItem(at: selectedCategory) as? CategoriesCell
            previousCell?.setDefaultBorder()
            cell?.setSelectedBorder()
            selectedCategory = selectedIndexpath
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = diffableDataSource?.itemIdentifier(for: indexPath) else {return}
        switch item{
        case .categories(let categorie):
            print("tapped Categories \(categorie.name)")
            selectionCategory(selectedIndexpath: indexPath)
            updateProductsSection(categoryNumber: indexPath.item)
        case .products(let product):
            print("tapped Products \(product)") // идем на детальный экран
        case .searchBar:
            break
        }
    }
}

// MARK: - Constraints
private extension HomeViewController{
    func setViews(){
        [
            collectionView,
        ].forEach { view.addSubview($0) }
    }
    
    func layoutViews(){
        view.backgroundColor = .white
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(62)
            make.bottom.equalToSuperview()
        }
    }
}
// MARK: - HeaderProductsViewDelegate
extension HomeViewController: HeaderProductsDelegate{
    func choseFiltration(filterType: FilterModel) {
        switch filterType{
        case .nameAlphabet:
            var productsToSortArray = products
            productsToSortArray.sort { $0.description < $1.description }
            prodArray = productsToSortArray.map { .products($0) }
            applyDiffableSnapShot()
        case .priceDescending:
            var productsToSortArray = products
            productsToSortArray.sort { $0.price > $1.price }
            prodArray = productsToSortArray.map { .products($0) }
            applyDiffableSnapShot()
        case .noFilter:
            prodArray = products.map { .products($0) }
            applyDiffableSnapShot()
        case .priceAscending:
            var productsToSortArray = products
            productsToSortArray.sort { $0.price < $1.price }
            prodArray = productsToSortArray.map { .products($0) }
            applyDiffableSnapShot()
        }
    }
}

extension HomeViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        print(searchText) // переход на экран с поиском
    }
}
