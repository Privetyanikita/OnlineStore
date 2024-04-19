//
//  SerchViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit

class SearchViewController: BaseViewController {
    
    private var diffableDataSourceResult: UICollectionViewDiffableDataSource<SectionSearchModel, ProductsModel>?
    private var diffableDataSourceSaves: UICollectionViewDiffableDataSource<SectionsSavesModel, SavesSerchesModel>?
    
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
    private var saveSearches: [SavesSerchesModel] = []
    
    private var sectionsSearchResult: [SectionSearchModel] = SectionSearchModel.allCases
    private var sectionsSavesReserches: [SectionsSavesModel] =  SectionsSavesModel.allCases
    
    private let collectionViewSearchResult: SearchResultCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = SearchResultCollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    private let collectionViewSerchSaves: SavesSearchesCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = SavesSearchesCollectionView(frame: .zero, collectionViewLayout: layout)
        view.isHidden = true
        return view
    }()
    
    private var headerDelegate: HeaderProductsViewDelegate?
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        saveSearches = saveHistory(saveType: .saveSerchWordHome, savesSerches: saveSearches, serchToSave: searchWord, id: nil)
        hookUpNavBar()
        setViews()
        layoutViews()
        setUPDelegates()
        setupDataSourceResult()
        setupDataSourceSaves()
        applySnapShotResults(products: products)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        StoreManager.shared.getCustomData(forKey: .saveSearches) { (savedSearches: [SavesSerchesModel]) in
            self.saveSearches = savedSearches
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setUPDelegates(){
        collectionViewSearchResult.delegate = self
        collectionViewSerchSaves.delegate = self
    }
    
    private func hideCollectionView(isHideSavesCollection: Bool, isHideResultCollection: Bool){
        collectionViewSerchSaves.isHidden = isHideSavesCollection
        collectionViewSearchResult.isHidden = isHideResultCollection
    }
    
    private func saveHistory(saveType: SaveSearchHistory, savesSerches: [SavesSerchesModel], serchToSave: String, id: UUID?) -> [SavesSerchesModel]{
        var historySearches  = savesSerches
        let objectToSave = SavesSerchesModel(saveSearch: serchToSave)
        switch saveType{
        case .saveSerchWordHome:
            historySearches.append(objectToSave)
            StoreManager.shared.getCustomData(forKey: .saveSearches) { (savedSearches: [SavesSerchesModel]) in
                historySearches = savedSearches
                historySearches.append(objectToSave)
                StoreManager.shared.saveCustomData(object: historySearches, forKey: .saveSearches)
            }
            return historySearches
        case .saveSerchWordResult:
            historySearches.append(objectToSave)
            StoreManager.shared.saveCustomData(object: historySearches, forKey: .saveSearches)
            return historySearches
        case .deleteOne:
            if let index = historySearches.firstIndex(where: { $0.id == id }) {
                historySearches.remove(at: index)
                StoreManager.shared.saveCustomData(object: historySearches, forKey: .saveSearches)
                return historySearches
            }
            return historySearches
        case .deleteAll:
            historySearches = []
            StoreManager.shared.remove(forKey: .saveSearches)
            return historySearches
        }
    }
    
    private func saveSearchWord(){
        saveSearches.append(SavesSerchesModel(saveSearch: self.searchWord))
        StoreManager.shared.getCustomData(forKey: .saveSearches) { (savedSearches: [SavesSerchesModel]) in
            self.saveSearches = savedSearches
            self.saveSearches.append(SavesSerchesModel(saveSearch: self.searchWord))
            StoreManager.shared.saveCustomData(object: self.saveSearches, forKey: .saveSearches)
        }
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
// MARK: - ConfigDiffableDataSource
private extension SearchViewController{
    func setupDataSourceResult(){
        diffableDataSourceResult = .init(collectionView: collectionViewSearchResult, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = SectionSearchModel(rawValue: indexPath.section) else { return UICollectionViewCell()}
            switch section{
            case .searchResult:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.resuseID, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
                cell.configCell(descText: itemIdentifier.description, priceText: itemIdentifier.price, image: itemIdentifier.image, isLiked: nil, isRemoveFavor: true)
                cell.onButtonTap = { event in
                    switch event{
                    case .addToCartTapped:
                        print(itemIdentifier.id) //добавить в корзину
                    case .addToWishList:
                         break
                    }
                }
                return cell
            }
        })
        
        diffableDataSourceResult?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderProductsView.resuseID, for: indexPath) as? HeaderProductsView else { return nil }
            let section = self.sectionsSearchResult[indexPath.section]
            header.configureHeader(sectionTitle: section.title + self.searchWord, type: .searchResult)
            header.delegate = self
            self.headerDelegate = header
            return header
        }
    }
    
    func setupDataSourceSaves(){
        diffableDataSourceSaves = .init(collectionView: collectionViewSerchSaves, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = SectionsSavesModel(rawValue: indexPath.section) else { return UICollectionViewCell()}
            switch section{
            case .savesSerches:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.resuseID, for: indexPath) as? SearchResultCell else { return UICollectionViewCell() }
                cell.configCell(savesSearches: itemIdentifier.saveSearch)
                cell.onButtonTap = { event in
                    switch event{
                    case .delete:
                        self.saveSearches = self.saveHistory(saveType: .deleteOne, savesSerches: self.saveSearches, serchToSave: "", id: itemIdentifier.id)
                        self.applySnapShotSaves()
                    }
                }
                return cell
            }
        })
        
        diffableDataSourceSaves?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSavesSerches.resuseID, for: indexPath) as? HeaderSavesSerches else { return nil }
            let section = self.sectionsSavesReserches[indexPath.section]
            header.configureHeader(sectionTitle: section.title)
            header.delegate = self
            return header
        }
    }
    
    func applySnapShotResults(products: [ProductsModel]){
        DispatchQueue.main.async { [self] in
            var snapShot = NSDiffableDataSourceSnapshot<SectionSearchModel, ProductsModel>()
            snapShot.appendSections([.searchResult])
            snapShot.appendItems(products, toSection: .searchResult)
            diffableDataSourceResult?.apply(snapShot, animatingDifferences: true)
        }
    }
    
    func applySnapShotSaves(){
        DispatchQueue.main.async { [self] in
            var snapShot = NSDiffableDataSourceSnapshot<SectionsSavesModel, SavesSerchesModel>()
            snapShot.appendSections([.savesSerches])
            snapShot.appendItems(saveSearches, toSection: .savesSerches)
            diffableDataSourceSaves?.apply(snapShot, animatingDifferences: true)
        }
    }
}
// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewSearchResult{
            guard let item = diffableDataSourceResult?.itemIdentifier(for: indexPath) else { return }
            print(item) 
            router.push(DetailViewController(),animated: true) // переход на детальный экран
        } else if collectionView == collectionViewSerchSaves {
            guard let item = diffableDataSourceSaves?.itemIdentifier(for: indexPath) else { return }
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
            applySnapShotResults(products: productsToSortArray)
        case .priceDescending:
            var productsToSortArray = products
            productsToSortArray.sort { $0.price > $1.price }
            applySnapShotResults(products: productsToSortArray)
        case .noFilter:
            applySnapShotResults(products: products)
        case .priceAscending:
            var productsToSortArray = products
            productsToSortArray.sort { $0.price < $1.price }
            applySnapShotResults(products: productsToSortArray)
        }
    }
}

// MARK: - HeaderSearchResultDelegate
extension SearchViewController: HeaderSavesSerchesDelegate{
    func cancelButtontapped() {
        saveSearches = saveHistory(saveType: .deleteAll, savesSerches: saveSearches, serchToSave: "", id: nil)
        applySnapShotSaves()
    }
}
// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        applySnapShotSaves()
        hideCollectionView(isHideSavesCollection: false, isHideResultCollection: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text
        if let searchText{
            saveSearches = saveHistory(saveType: .saveSerchWordResult, savesSerches: saveSearches, serchToSave: searchText, id: nil)  //cохраняем в UserDefaults
            headerDelegate?.changeHeaderTitle(serchWord: searchText)
            //запрос в сеть передаем searchText
        }
        hideCollectionView(isHideSavesCollection: true, isHideResultCollection: false)
        searchBar.resignFirstResponder()
    }
}

// MARK: - Constraints
private extension SearchViewController{
    func setViews(){
        [
            collectionViewSearchResult,
            collectionViewSerchSaves,
        ].forEach { view.addSubview($0) }
    }
    
    func layoutViews(){
        view.backgroundColor = .white
        collectionViewSearchResult.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(62)
            make.bottom.equalToSuperview()
        }
        
        collectionViewSerchSaves.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(62)
            make.bottom.equalToSuperview()
        }
    }
}
