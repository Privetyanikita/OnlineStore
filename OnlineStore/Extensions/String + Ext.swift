//
//  String + Ext.swift
//  OnlineStore
//
//  Created by Polina on 25.04.2024.
//

import Foundation
extension String {
    func cleanImageUrl() -> String {
        if self.first == "[" {
            return self.replacingOccurrences(of: "[\"", with: "").replacingOccurrences(of: "\"]", with: "")
        }
        return self
    }
}
