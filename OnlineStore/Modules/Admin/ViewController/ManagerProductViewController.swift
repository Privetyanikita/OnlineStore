//
//  ManagerProductViewController.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 24.04.2024.
//

import UIKit

class ManagerProductViewController: BaseViewController {
    
    private let flow: ManagerFlow
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = ManagerProductView(flow: flow)
    }

}
