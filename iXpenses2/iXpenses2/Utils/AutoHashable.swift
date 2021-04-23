//
//  AutoHashable.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 24.03.2021.
//

import Foundation

protocol AutoHashable: Hashable {}

extension AutoHashable {
    public func hash(into hasher: inout Hasher) {
        let mirror = Mirror(reflecting: self)

        for child in mirror.children {
            if let value = child.value as? AnyHashable {
                hasher.combine(value)
            }
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

