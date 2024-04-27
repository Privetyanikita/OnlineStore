//
//  ManagerViewController.swift
//  OnlineStore
//
//  Created by Polina on 24.04.2024.
//

import UIKit

import UIKit

enum ManagerFlow {
    case addNewProduct
    case updateProduct
    case deleteProduct
    case createCategory
    case updateCategory
    case deleteCategory
}

class ManagerViewController: BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    override func loadView() {
        super.loadView()
        let managerView = ManagerView()
        managerView.onAddNewProductTap = addNewProduct
        managerView.onUpdateProductTap = updateProduct
        managerView.onDeleteProductTap = deleteProduct
        managerView.onCreateCategoryTap = createCategory
        managerView.onUpdateCategoryTap = updateCategory
        managerView.onDeleteCategoryTap = deleteCategory
        view = managerView
    }
    
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
       CustomNavigationBarConfiguration(
        title: Text.manager,
        withSearchTextField: false,
        isSetupBackButton: false,
        rightButtons: [])
    }
    
    private func addNewProduct() {
        let vc = ManagerProductViewController(flow: .addNewProduct)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func updateProduct() {
        let vc = ManagerProductViewController(flow: .updateProduct)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func deleteProduct() {
        let vc = ManagerProductViewController(flow: .deleteProduct)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func createCategory() {
        let vc = ManagerCategoryViewController(flow: .createCategory)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func updateCategory() {
        let vc = ManagerCategoryViewController(flow: .updateCategory)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func deleteCategory() {
        let vc = ManagerCategoryViewController(flow: .deleteCategory)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}
