//
//  DetailViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 15.04.24.
//

import UIKit
import SnapKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarItems()
        configureViewController()
    }

    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
       CustomNavigationBarConfiguration(
        title: Text.detailsProduct,
        withSearchTextField: false,
        isSetupBackButton: true,
        rightButtons: [.shoppingCart])
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
    }
    
    
    private func  configureViewController() {
        view.backgroundColor = .systemBackground
        view.addSubview(productCollectionView)
        view.addSubview(productTitleView)
        
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        productCollectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.reuseID)
        
        layoutViews()
        configureItems()
    }
    
    
    private func configureItems() {
        productTitleView.configure(product: "Air pods max by Apple", price: "$ 1999,99")
    }
    
    
    private func layoutViews(){
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(290)
        }
        
        productTitleView.snp.makeConstraints { make in
            make.top.equalTo(productCollectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
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

