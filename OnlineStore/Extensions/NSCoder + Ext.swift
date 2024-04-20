//
//  NSCoder + Ext.swift
//  OnlineStore
//
//  Created by Mikhail Ustyantsev on 20.04.2024.
//

import Foundation

extension NSCoder {
    
    static func fatalErrorNotImplemented() -> Never {
        fatalError("init(coder:) has not been implemented")
    }
}
