//
//  SerchViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

class SearchViewController: BaseViewController {
    
    private var searchWord: String
    
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
    
    private let searchView = SearchView()

    init(searchWord: String) {
        self.searchWord = searchWord
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
        CustomNavigationBarConfiguration(
            title: "",
            withSearchTextField: true,
            isSetupBackButton: true,
            rightButtons: [.shoppingCart])
    }
    
    override func loadView() {
        super.loadView()

        searchView.searchWord = searchWord
        searchView.setUPDelegates(delegeteResult: self,
                                  delegateSaves: self,
                                  headerDelegateSaves: self,
                                  headerDelegateResult: self,
                                  delegate: self)
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        SearchResultManager.shared.saveHistorySearchWord(searchWord: searchWord)
        hookUpNavBar()
        searchView.applySnapShotResults(products: products) //убрать когда будет запрос в сеть и вызывать уже там когда данные будут получены когда подключу сеть посмотреть будет ли без этого header приходить
        customNavigationBar.searchTextField.text = searchWord
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - SetUP NavBar
private extension SearchViewController{
    func hookUpNavBar() {
        customNavigationBar.searchTextField.delegate = self
        customNavigationBar.shoppingCartButton.addTarget(self, action: #selector(shoppingCartButtonTapped), for: .touchUpInside)
        customNavigationBar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc func shoppingCartButtonTapped() {
        print(">> SHOPPING CART BTN tapped")
    }
    
    @objc private func backButtonTapped() {
        print(">> BACK BTN tapped")
        router.back()
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0{
            guard let item = searchView.getItemResult(index: indexPath) else { return }
            print(item)
            router.push(DetailViewController(),animated: true) // переход на детальный экран
        } else if collectionView.tag == 1 {
            guard let item = searchView.getItemSerch(index: indexPath) else { return }
            customNavigationBar.searchTextField.text = item.saveSearch
            customNavigationBar.searchTextField.becomeFirstResponder()
        }
    }
}
// MARK: - HeaderProductsViewDelegate
extension SearchViewController: HeaderProductsDelegate{
    func choseFiltration(filterType: FilterModel) {
        switch filterType{
        case .nameAlphabet:
            var productsToSortArray = products
            productsToSortArray.sort { $0.description < $1.description }
            searchView.applySnapShotResults(products: productsToSortArray)
        case .priceDescending:
            var productsToSortArray = products
            productsToSortArray.sort { $0.price > $1.price }
            searchView.applySnapShotResults(products: productsToSortArray)
        case .noFilter:
            searchView.applySnapShotResults(products: products)
        case .priceAscending:
            var productsToSortArray = products
            productsToSortArray.sort { $0.price < $1.price }
            searchView.applySnapShotResults(products: productsToSortArray)
        }
    }
}

// MARK: - HeaderSearchResultDelegate
extension SearchViewController: HeaderSavesSerchesDelegate{
    func cancelButtontapped() {
        let history =  SearchResultManager.shared.saveHistory(saveType: .deleteAll,  serchToSave: "", id: nil)
       searchView.applySnapShotSaves(saveSearches: history)
    }
}
// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchView.applySnapShotSaves(saveSearches: SearchResultManager.shared.saveSearches)
        searchView.hideCollectionView(isHideSavesCollection: false,
                                      isHideResultCollection: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text
        if let searchText{
            _ = SearchResultManager.shared.saveHistory(saveType: .saveSearchWordResult, serchToSave: searchText, id: nil)  //cохраняем в UserDefaults
            searchView.headerDelegate?.changeHeaderTitle(serchWord: searchText) // меняем title у header
            //запрос в сеть передаем searchText
        }
        searchView.hideCollectionView(isHideSavesCollection: true,
                                      isHideResultCollection: false)
        searchBar.resignFirstResponder()
    }
}
// MARK: - SearchViewDelegateProtocol
extension SearchViewController: SearchViewDelegateProtocol{
    func addToCart(item: ProductsModel) {
        print("item \(item)")
    }
    
    func deleteOneHistorySearch(id: UUID) {
        let history = SearchResultManager.shared.saveHistory(saveType: .deleteOne,  serchToSave: "", id: id)
        searchView.applySnapShotSaves(saveSearches: history)
    }
}
