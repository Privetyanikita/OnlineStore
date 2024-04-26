//
//  ManagerCategoryViewController.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 24.04.2024.
//

import UIKit

class ManagerCategoryViewController: BaseViewController {

    private let flow: ManagerFlow

    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
        let navBarTitle: String
        switch flow {
        case .createCategory:
            navBarTitle = Text.createCategory
        case .updateCategory:
            navBarTitle = Text.updateCategory
        default:
            navBarTitle = Text.deleteCategory
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
    
}
