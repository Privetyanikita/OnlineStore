//
//  Constants.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 16.04.2024.
//

import UIKit

enum Color {
    static let customGreen = UIColor(named: "CustomGreen")
    static let customLightGrey = UIColor(named: "CustomLightGrey")
    static let customPurple = UIColor(named: "CustomPurple")
   
}

enum Image {
    static let arrowLeft = UIImage(named: "arrow-left")
    static let shoppingCart = UIImage(named: "shopping-cart")
    static let alarmClock = UIImage(named: "alarm") 
    static let bell = UIImage(systemName: "bell")
    static let systemCart = UIImage(systemName: "cart")
    static let chevronDown = UIImage(systemName: "chevron.down")
    static let emptyHeart = UIImage(named: "Heart")
    static let isLikedHeart = UIImage(named: "liked")
    static let hide = UIImage(named: "hide")
    static let angleRight = UIImage(named: "angle-right")
}

enum Text {
    static let detailsProduct = "Details product"
    static let deliveryAddress = "Delivery address"
    static let profile = "Profile"
    static let cart = "Your Cart"
    static let descriptionOfProduct = "Description of product"
    static let addToCart = "Add to Cart"
    static let buyNow = "Buy Now"
    static let payment = "Payment method"
    
    //Registration
    static let login = "Login"
    static let register = "Register"
    static let cancel = "Cancel"
    static let signUp = "Sign Up"
    static let signIn = "Sign In"
    static let signOut = "Sign Out"
    static let forgotYourPassword = "Forgot your password?"
    static let completeYourAccount = "Complete your account"
    static let alreadyHaveAnAccount = "Already have an account?"
    static let dontHaveAnAccount = "Don't have an account?"
    static let doYouReallyWantToSignOutYourAccount = "Do you really want to sign out your account?"
    static let typeOfAccount = "Type of account"
    static let userName = "User name"
    static let enterYourName = "Enter your name"
    static let email = "E-mail"
    static let enterYourEmail = "Enter your e-mail"
    static let password = "Password"
    static let enterYourPassword = "Enter your password"
    static let confirmPassword = "Confirm password"
    static let confirmYourPassword = "Confirm your password"
}
