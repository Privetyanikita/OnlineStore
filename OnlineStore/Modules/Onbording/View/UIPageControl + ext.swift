//
//  UIPageControl + ext.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//

import UIKit
extension UIPageControl {
    var page: Int {
        get {
            return currentPage
        }
        set {
            currentPage = newValue

            let indicatorSize = CGSize(width: 24, height: 24)
            let indicatorImage = UIGraphicsImageRenderer(size: indicatorSize).image { context in
                let originalImage = UIImage(systemName: "play.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
                let originalSize = originalImage?.size ?? .zero
                let rect = CGRect(x: (indicatorSize.width - originalSize.width) / 2, y: (indicatorSize.height - originalSize.height) / 2, width: originalSize.width, height: originalSize.height)
                originalImage?.draw(in: rect)
            }
            setIndicatorImage(indicatorImage, forPage: newValue)

            for indx in 0..<numberOfPages where indx != newValue {
                let indicatorImage = UIGraphicsImageRenderer(size: indicatorSize).image { context in
                    let originalImage = UIImage(systemName: "circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
                    let originalSize = originalImage?.size ?? .zero
                    let rect = CGRect(x: (indicatorSize.width - originalSize.width) / 2, y: (indicatorSize.height - originalSize.height) / 2, width: originalSize.width, height: originalSize.height)
                    originalImage?.draw(in: rect)
                }
                setIndicatorImage(indicatorImage, forPage: indx)
            }
        }
    }
}
