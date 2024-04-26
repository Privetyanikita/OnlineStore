//
//  HomeViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit
import SnapKit
import Route

class HomeViewController: BaseViewController {
    
    private let homeView = HomeView()
    
    private var products: [Product] = .init()
    private var categories: [Category] = .init()
    private var categorySection: [ItemModel] = .init()
    private var productsSection: [ItemModel] = .init()
    private let allCategory: Category =  .init(id: 999999999, name: "All", image: "All")
    
    override func loadView() {
        super.loadView()

        homeView.setUPDelegates(delegateCollectionView: self,
                                headerDelegate: self,
                                searchBarDelegate: self,
                                delegate: self)
        view = homeView
    }
    
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
       CustomNavigationBarConfiguration(
        title: "",
        withSearchTextField: false,
        withLocationView: true,
        isSetupBackButton: false,
        rightButtons: [.shoppingCart, .notification])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hookUpNavBarButtons()
        getCategories()
        getAllProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
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
        router.push(CartViewController(), animated: true)
    }
}

// MARK: - Private Methods
private extension HomeViewController{
    func insertAll(){
        if categories.count >= 5 {
            categories.insert(allCategory, at: 4)
        }
    }
    
    func updateProductsSection(categoryNumber: Int, categoryId: Int){
        if categoryNumber == 4{
            categorySection = (categorySection.count > 5) 
            ? categories.prefix(5).map { .categories($0)}
            : categories.map { .categories($0)}
            homeView.applyDiffableSnapShot(products: productsSection, categories: categorySection)
        } else {
            getProductsByCategory(categoryId: categoryId)
        }
    }
    
    func selectionCategory(selectedIndexpath: IndexPath, collectionView: UICollectionView){
        if selectedIndexpath.item != 4{
            let cell = collectionView.cellForItem(at: selectedIndexpath) as? CategoriesCell
            let previousCell = collectionView.cellForItem(at: homeView.selectedCategory) as? CategoriesCell
            previousCell?.setDefaultBorder()
            cell?.setSelectedBorder()
            homeView.selectedCategory = selectedIndexpath
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = homeView.getItem(index: indexPath) else {return}
        switch item{
        case .categories(let category):
            print("tapped Categories \(category.name)")
            selectionCategory(selectedIndexpath: indexPath, collectionView: collectionView)
            updateProductsSection(categoryNumber: indexPath.item, categoryId: category.id)
        case .products(let product):
            print("tapped Products \(product)") // идем на детальный экран
            router.push(DetailViewController(product: product),animated: true)
        case .searchBar:
            break
        }
    }
}

// MARK: - HeaderProductsViewDelegate
extension HomeViewController: HeaderProductsDelegate{
    func choseFiltration(filterType: FilterModel) {
        switch filterType{
        case .nameAlphabet:
            var productsToSortArray = products
            productsToSortArray.sort { $0.title < $1.title }
            productsSection = productsToSortArray.map { .products($0) }
            homeView.applyDiffableSnapShot(products: productsSection, categories: categorySection)
        case .priceDescending:
            var productsToSortArray = products
            productsToSortArray.sort { $0.price > $1.price }
            productsSection = productsToSortArray.map { .products($0) }
            homeView.applyDiffableSnapShot(products: productsSection, categories: categorySection)
        case .noFilter:
            productsSection = products.map { .products($0) }
            homeView.applyDiffableSnapShot(products: productsSection, categories: categorySection)
        case .priceAscending:
            var productsToSortArray = products
            productsToSortArray.sort { $0.price < $1.price }
            productsSection = productsToSortArray.map { .products($0) }
            homeView.applyDiffableSnapShot(products: productsSection, categories: categorySection)
        }
    }
}
// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        router.push(SearchViewController(searchWord: searchText),animated: true) // переход на SearchViewController
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

// MARK: - Network
private extension HomeViewController{
    func getProductsByCategory(categoryId: Int){
        NetworkManager.shared.fetchFilteredProducts(categoryId: categoryId) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result{
                case .success(let dataByCategory):
                    products = dataByCategory
                    productsSection = products.map { .products($0)}
                    homeView.applyDiffableSnapShot(products: productsSection,
                                                   categories: categorySection)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getAllProducts(){
        NetworkManager.shared.fetchProducts { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result{
                case .success(let dataAllProducts):
                    products = dataAllProducts
                    productsSection = products.map { .products($0)}
                    homeView.applyDiffableSnapShot(products: productsSection,
                                                   categories: categorySection)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getCategories(){
        NetworkManager.shared.fetchCategories { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result{
                case .success(let dataCategory):
                    categories = dataCategory
                    insertAll()
                    categorySection = categories.prefix(5).map { .categories($0)}
                    homeView.applyDiffableSnapShot(products: productsSection,
                                                   categories: categorySection)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - HomeViewDelegateProtocol
extension HomeViewController: HomeViewDelegateProtocol{
    func addToCart(item: Product) {
        print("Add To Cart Homev \(item)") //добавляем в корзину
        CartManager.shared.addProductToCart(item)
    }
}
