//
//  OnbordingModel.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//

import Foundation

struct OnbordingModel{
    let image: String
    let title: String
    let subTitle: String
}

extension OnbordingModel{
    static func  getOnbordingModel() -> [OnbordingModel]{
        [
            .init(image: "FirstOnbording", title: "20% Discount New Arrival Product", subTitle: "Publish up your selfies to make your self more beautiful with this app"),
            .init(image: "SecondOnbording", title: "Take Advantage of The Offer Shopping", subTitle: "Publish up your selfies to make your self more beautiful with this app"),
            .init(image: "ThirdOnbording", title: "All Types Offers Within Your Reach", subTitle: "Publish up your selfies to make your self more beautiful with this app"),
       ]
    }
}
