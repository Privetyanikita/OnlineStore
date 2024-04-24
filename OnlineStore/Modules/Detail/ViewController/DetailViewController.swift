//
//  DetailViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit
import SnapKit
import Route

class DetailViewController: BaseViewController {

    var colors: [UIColor] = [.systemYellow, .systemOrange,. systemTeal]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        configureViewController()
        setupNavBarItems()
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
        
        contentView.addSubview(productCollectionView)
        contentView.addSubview(productTitleView)
        contentView.addSubview(productDescriptionView)
        contentView.addSubview(productBottomView)
        
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        productCollectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.reuseID)
        
        layoutViews()
        configureItems()
    }
    
    
    private func configureItems() {
        productTitleView.configure(product: "Air pods max by Apple", price: "$ 1999,99")
        productDescriptionView.configure(with: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
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
            make.height.equalTo(290)
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
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.reuseID, for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(colors[indexPath.item])
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

