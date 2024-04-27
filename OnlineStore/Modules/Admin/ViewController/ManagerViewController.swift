//
//  ManagerViewController.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 24.04.2024.
//

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
    
    override func loadView() {
        super.loadView()
        let managerView = ManagerView()
        managerView.onAddNewProductTap = addNewProduct
        managerView.onUpdateProductTap = updateProduct
        managerView.onDeleteProductTap = deleteProduct
        managerView.onCreateCategoryTap = createCategory
        managerView.onUpdateCategoryTap = updateCategory
        managerView.onDeleteProductTap = deleteCategory
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
        
    }
    
    private func deleteProduct() {
        
    }
    
    private func createCategory() {
    }
    
    private func updateCategory() {
        
    }
    
    private func deleteCategory() {
        
    }

}
