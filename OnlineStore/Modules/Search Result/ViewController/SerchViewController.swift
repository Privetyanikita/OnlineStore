//
//  SerchViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

class SearchViewController: BaseViewController {
    
    private var searchWord: String
    
    private var products: [Product] = .init()
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
        SearchResultManager.shared.delegate = self
        SearchResultManager.shared.saveHistorySearchWord(searchWord: searchWord)
        hookUpNavBar()
        getProductsByTitle(title: searchWord)
        customNavigationBar.searchTextField.text = searchWord
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        router.push(CartViewController(), animated: true)
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
            router.push(DetailViewController(product: item),animated: true) // переход на детальный экран
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
            productsToSortArray.sort { $0.title < $1.title }
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
        SearchResultManager.shared.saveHistory(saveType: .deleteAll,  serchToSave: "", id: nil)
       //searchView.applySnapShotSaves(saveSearches: history)
    }
}
// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        //searchView.applySnapShotSaves(saveSearches: SearchResultManager.shared.saveSearches)
        searchView.hideCollectionView(isHideSavesCollection: false,
                                      isHideResultCollection: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text
        if let searchText{
            SearchResultManager.shared.saveHistory(saveType: .saveSearchWordResult, serchToSave: searchText, id: nil)  //cохраняем в UserDefaults
            searchView.headerDelegate?.changeHeaderTitle(serchWord: searchText) // меняем title у header
            getProductsByTitle(title: searchText) //запрос в сеть передаем searchText
        }
        searchView.hideCollectionView(isHideSavesCollection: true,
                                      isHideResultCollection: false)
        searchBar.resignFirstResponder()
    }
}
// MARK: - Network
private extension SearchViewController{
    func getProductsByTitle(title: String){
        NetworkManager.shared.searchProductsByTitle(title: title, completion: { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result{
                case .success(let dataByTitle):
                    products = dataByTitle
                    searchView.applySnapShotResults(products: products)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        })
    }
}
// MARK: - SearchViewDelegateProtocol
extension SearchViewController: SearchViewDelegateProtocol{
    func addToCart(item: Product) {
        print("item \(item)")
        CartManager.shared.addProductToCart(item)
    }
    
    func deleteOneHistorySearch(id: UUID) {
        SearchResultManager.shared.saveHistory(saveType: .deleteOne,  serchToSave: "", id: id)
        //searchView.applySnapShotSaves(saveSearches: history)
    }
}

extension SearchViewController: SearchResultManagerProtocol{
    func updateSaveSearches(saveSearches: [SavesSerchesModel]) {
        searchView.applySnapShotSaves(saveSearches: saveSearches)
    }
}
