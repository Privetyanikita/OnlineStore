//
//  UIViewController + ext.swift
//  OnlineStore
//
//  Created by Polina on 19.04.2024.
//

import UIKit
import Route
extension UIViewController {

    var router: Router {
        return Router(window: UIApplication.shared.keyWindow, controller: self)
    }
}
