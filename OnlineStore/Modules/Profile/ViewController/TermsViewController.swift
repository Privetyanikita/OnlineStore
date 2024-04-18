//
//  TermsViewController.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 16.04.2024.
//

import UIKit

class TermsViewController: UIViewController {

    override func loadView() {
        super.loadView()
        let termsView = TermsView()
        termsView.onCloseTap = { self.dismiss(animated: true) }
        view = termsView
    }

}
