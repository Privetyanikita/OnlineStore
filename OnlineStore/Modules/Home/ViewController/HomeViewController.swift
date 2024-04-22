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
    
    private let homeView = HomeView()
    private let allGategories: CategoriesModel =  .init(id: 99999, name: "All", image: "All")
    
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
        insetAll()
        prodArray = products.map { .products($0)}
        categArray = categories.prefix(5).map { .categories($0)}
        homeView.applyDiffableSnapShot(products: prodArray, categories: categArray)
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
    }
}

// MARK: - Private Methods
private extension HomeViewController{
    func insetAll(){
        if categories.count > 5 {
            categories.insert(allGategories, at: 4)
        }
    }
    
    func updateProductsSection(categoryNumber: Int){
        if categoryNumber == 4{
            categArray = (categArray.count > 5) 
            ? categories.prefix(5).map { .categories($0)}
            : categories.map { .categories($0)}
            homeView.applyDiffableSnapShot(products: prodArray, categories: categArray)
        } else {
            //запрос в сеть
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
        case .categories(let categorie):
            print("tapped Categories \(categorie.name)")
            selectionCategory(selectedIndexpath: indexPath, collectionView: collectionView)
            updateProductsSection(categoryNumber: indexPath.item)
        case .products(let product):
            print("tapped Products \(product)") // идем на детальный экран
            router.push(DetailViewController(),animated: true)
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
            productsToSortArray.sort { $0.description < $1.description }
            prodArray = productsToSortArray.map { .products($0) }
            homeView.applyDiffableSnapShot(products: prodArray, categories: categArray)
        case .priceDescending:
            var productsToSortArray = products
            productsToSortArray.sort { $0.price > $1.price }
            prodArray = productsToSortArray.map { .products($0) }
            homeView.applyDiffableSnapShot(products: prodArray, categories: categArray)
        case .noFilter:
            prodArray = products.map { .products($0) }
            homeView.applyDiffableSnapShot(products: prodArray, categories: categArray)
        case .priceAscending:
            var productsToSortArray = products
            productsToSortArray.sort { $0.price < $1.price }
            prodArray = productsToSortArray.map { .products($0) }
            homeView.applyDiffableSnapShot(products: prodArray, categories: categArray)
        }
    }
}
// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        print(searchText) // переход на экран с поиском
        router.push(SearchViewController(searchWord: searchText),animated: true)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

// MARK: - HomeViewDelegateProtocol
extension HomeViewController: HomeViewDelegateProtocol{
    func addToCart(item: ProductsModel) {
        print("Add To Cart Homev \(item)") //добавляем в корзину
    }
}
