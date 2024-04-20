//
//  PaymentViewController.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 20.04.2024.
//

import UIKit

class PaymentViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        presentSuccessVC()
    }
    
    override func loadView() {
        super.loadView()
        view = PaymentView()
    }
    
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
       CustomNavigationBarConfiguration(
        title: Text.payment,
        withSearchTextField: false,
        isSetupBackButton: true,
        rightButtons: [.shoppingCart])
    }
    
    private func presentSuccessVC() {
        let successVC = PaymentSuccessViewController()
        successVC.onDismiss = { self.dismiss(animated: true) }
        if let sheet = successVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           self.present(successVC, animated: true)
        }
    }
}
