//
//  FontEnum.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 16.04.24.
//

import UIKit

enum Font:String{
    case black = "Inter-Black"
    case bold = "Inter-Bold"
    case extraBold = "Inter-ExtraBold"
    case extraLight = "Inter-ExtraLight"
    case light = "Inter-Light"
    case medium = "Inter-Medium"
    case regular = "Inter-Regular"
    case semiBold = "Inter-SemiBold"
    case thin = "Inter-Thin"
    
    static func getFont(_ font: Font, size: CGFloat) -> UIFont {
        return UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
