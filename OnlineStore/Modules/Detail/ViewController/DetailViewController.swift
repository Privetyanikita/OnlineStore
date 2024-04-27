//
//  DetailViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit
import SnapKit
import Route

final class DetailViewController: BaseViewController {

    private var product: Product
    private var cleanImageArray: [String] = .init()
    
    private let productCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let productTitleView = ProductTitleView()
    let productDescriptionView = ProductDescriptionView()
    let productBottomView = ProductBottomView()
    
    let scrollView            = UIScrollView()
    let contentView           = UIView()
    
    init( product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        configureViewController()
        setupNavBarItems()
        cleanImagesArray()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
       CustomNavigationBarConfiguration(
        title: Text.detailsProduct,
        withSearchTextField: false,
        isSetupBackButton: true,
        rightButtons: [.shoppingCart])
    }
    
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delaysContentTouches = false
        
        scrollView.snp.makeConstraints({ make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(1)
            make.leading.trailing.bottom.equalToSuperview()
        })
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.edges.equalToSuperview()
        }
    }
    
    
    private func setupNavBarItems() {
        customNavigationBar.searchTextField.delegate = self
        hookUpNavBarButtons()
    }
    
    
    private func hookUpNavBarButtons() {
        customNavigationBar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        customNavigationBar.notificationButton.addTarget(self, action: #selector(notificationsButtonTapped), for: .touchUpInside)
        customNavigationBar.shoppingCartButton.addTarget(self, action: #selector(shoppingCartButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func backButtonTapped() {
        router.back()
    }
    
    
    @objc private func notificationsButtonTapped() {
        print(">> NOTIFICATIONS BTN tapped")
    }
    
    
    @objc private func shoppingCartButtonTapped() {
        print(">> SHOPPING CART BTN tapped")
        router.push(CartViewController(), animated: true)
    }
    
    
    private func  configureViewController() {
        view.backgroundColor = .systemBackground
        productBottomView.delegate = self
        productTitleView.delegate = self
        contentView.addSubview(productCollectionView)
        contentView.addSubview(productTitleView)
        contentView.addSubview(productDescriptionView)
        contentView.addSubview(productBottomView)
        
        productTitleView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        productCollectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.reuseID)
        
        layoutViews()
        configureItems()
    }
    
    
    private func configureItems() {
        // здесь нужно сделать проверку есть ли в массиве products из WishListManager наш продукт и если есть то у продукта поменять isFavorite на true и уже после конфигурировать productTitleView
        productTitleView.configure(product: product.title, price: product.price, isFavorite: false)
        productDescriptionView.configure(with: product.description)
    }
    
    private func cleanImagesArray(){
        cleanImageArray = product.images.map { string in
            var cleanedString = string.cleanImageUrl()
            cleanedString = cleanedString.trimmingCharacters(in:  CharacterSet(charactersIn: "\""))
            return cleanedString
        }
    }
    
    private func layoutViews(){
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(290)
        }
        
        productTitleView.snp.makeConstraints { make in
            make.top.equalTo(productCollectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        productDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(productTitleView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        productBottomView.snp.makeConstraints { make in
            make.top.equalTo(productDescriptionView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}


extension DetailViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("searchText \(searchText)")
        }
}


extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.reuseID, for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(cleanImageArray[indexPath.item])
        return cell
    }
}


extension DetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
// MARK: - ProductBottomViewDelegate Add to Cart, Go to PaymentVC
extension DetailViewController: ProductBottomViewDelegate{
    func goTocart() {
        CartManager.shared.addProductToCart(product)
    }
    
    func buyNow() {
        let paymentVC = PaymentViewController()
        paymentVC.modalPresentationStyle = .fullScreen
        present(paymentVC, animated: true)
    }
}
// MARK: - ProductTitleViewDelegateProtocol Save or Delete to WishList
extension DetailViewController: ProductTitleViewDelegateProtocol{
    func addToWishList() {
        WishListManager.shared.saveProduct(item: product)
        print("Save product")
    }
    
    func deleteFromWishList() {
        WishListManager.shared.deleteProduct(item: product)
        print("Delete product")
    }
}



