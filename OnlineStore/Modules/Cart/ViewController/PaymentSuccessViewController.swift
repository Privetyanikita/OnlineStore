//
//  PaymentSuccessViewController.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 20.04.2024.
//

import UIKit

class PaymentSuccessViewController: UIViewController {
    
    var onDismiss: (() -> Void)?

    override func loadView() {
        super.loadView()
        let successView = PaymentSuccessView()
        successView.onContinueTap = exitPayment
        view = successView
    }
    
    private func exitPayment() {
        dismiss(animated: true)
        onDismiss?()
    }

}
