//
//  UIViewController + Ext.swift
//  OnlineStore
//
//  Created by Polina on 19.04.2024.
//

import UIKit
import Route

extension UIViewController {

    var router: Router {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return Router(window: windowScene?.windows.first, controller: self)
    }
}
