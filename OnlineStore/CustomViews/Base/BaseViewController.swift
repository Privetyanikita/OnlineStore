//
//  BaseViewController.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 17.04.2024.
//

import UIKit
import SnapKit

protocol BaseViewControllerProtocol: AnyObject {
    func configureNavigationBar() -> CustomNavigationBarConfiguration?
}


class BaseViewController: UIViewController, BaseViewControllerProtocol {
    
    let customNavigationBar = CustomNavigationBarImplementation()
    let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        customNavigationBar.setupConfiguration(configureNavigationBar())
    }

    
    func configureNavigationBar() -> CustomNavigationBarConfiguration? {
        fatalError("Необходимо переписать этот метод в наследуемом классе")
    }
}


extension BaseViewController {
    func setupCustomNavigationBar() {
        view.addSubview(customNavigationBar)
        view.bringSubviewToFront(customNavigationBar)
        view.addSubview(bottomBorder)
        
        customNavigationBar.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        bottomBorder.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(customNavigationBar.snp.bottom)
        }
    }
}
