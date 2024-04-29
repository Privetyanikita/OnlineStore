//
//  ManagerProductViewController.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 24.04.2024.
//

import UIKit

class ManagerProductViewController: BaseViewController {
    
    private let flow: ManagerFlow
    private var productToChange: Product? {
        didSet {
            setupProductToChange()
        }
    }
    private var categories: [Category]? {
        didSet {
            setupCategories()
        }
    }
    
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
        let navBarTitle: String
        switch flow {
        case .addNewProduct:
            navBarTitle = Text.addNewProduct
        case .updateProduct:
            navBarTitle = Text.updateProduct
        default:
            navBarTitle = Text.deleteProduct
        }
       return CustomNavigationBarConfiguration(
        title: navBarTitle,
        withSearchTextField: false,
        isSetupBackButton: false,
        rightButtons: [])
    }
    
    init(flow: ManagerFlow) {
        self.flow = flow
        super.init(nibName: nil, bundle: nil)
        getCategories()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        let managerProductView = ManagerProductView(flow: flow)
        managerProductView.onSelectImageTap = selectImage
        managerProductView.onMainActionButtonTap = handleProduct(product:)
        managerProductView.setDelegate = {self}
        view = managerProductView
    }
    
    private func setupCategories() {
        if let managerProductView = view as? ManagerProductView {
            managerProductView.setupCategories(categories ?? [Category]())
        }
    }
    
    private func setupProductToChange() {
        if let managerProductView = view as? ManagerProductView {
            guard let productToChange else { return }
            managerProductView.setupProductToChange(productToChange)
        }
    }
    
    private func selectImage() {
        let photoEditVC = PhotoEditViewController()
        photoEditVC.modalPresentationStyle = .overFullScreen
        photoEditVC.onChoiceMade = setupImage(image:)
        present(photoEditVC, animated: true)
    }
    
    private func handleProduct(product: ProductPost?) {
        if productToChange != nil && product?.images == nil && flow != .deleteProduct {
            let alertVC = UIAlertController(title: "Please set an image", message: nil, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertVC, animated: true)
            return
        }
        
        switch flow {
        case .addNewProduct:
            addNewProduct(product: product)
        case .updateProduct:
            if productToChange == nil {
                let alertVC = UIAlertController(title: "Please search product to update", message: nil, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default))
                present(alertVC, animated: true)
                return
            }
            updateProduct(product: product)
        default:
            if productToChange == nil {
                let alertVC = UIAlertController(title: "Please search product to delete", message: nil, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default))
                present(alertVC, animated: true)
                return
            }
            deleteProduct()
        }
    }
    
    private func addNewProduct(product: ProductPost?) {
        if let product {
            NetworkManager.shared.createProduct(product: product) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result{
                    case .success(let addedProduct):
                        let alertVC = UIAlertController(title: "New product \(addedProduct.title ?? "") successfuly added", message: nil, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                        present(alertVC, animated: true)
                    case .failure(let error):
                        print(error.localizedDescription)
                        let alertVC = UIAlertController(title: "Error adding new product", message: error.localizedDescription, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                        present(alertVC, animated: true)
                    }
                }
            }
        }
    }
    
    private func updateProduct(product: ProductPost?) {
        if let product {
            NetworkManager.shared.changeProduct(id: productToChange!.id, product: product) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                    case .success(let changedProduct):
                        let alertVC = UIAlertController(title: "Product \(changedProduct.title ?? "") successfuly updated", message: nil, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                        present(alertVC, animated: true)
                    case .failure(let error):
                        print(error.localizedDescription)
                        let alertVC = UIAlertController(title: "Error updating product", message: error.localizedDescription, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                        present(alertVC, animated: true)
                    }
                }
            }
        }
    }
    
    private func deleteProduct() {
        NetworkManager.shared.deleteProduct(id: productToChange!.id) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result{
                case .success(let done):
                    if done {
                        let alertVC = UIAlertController(title: "Product successfuly deleted", message: nil, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                        present(alertVC, animated: true)
                    } else {
                        let alertVC = UIAlertController(title: "Error deleting product", message: nil, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                        present(alertVC, animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let alertVC = UIAlertController(title: "Error deleting product", message: error.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                    present(alertVC, animated: true)
                }
            }
        }
    }
    
    private func setupImage(image: UIImage?) {
        if let managerProductView = view as? ManagerProductView {
            managerProductView.setupImage(image: image)
        }
    }
    
    private func getCategories(){
        NetworkManager.shared.fetchCategories { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let dataCategory):
                    categories = dataCategory
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

}


extension ManagerProductViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        NetworkManager.shared.searchProductsByTitle(title: searchText) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let products):
                    self.productToChange = products.first
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
