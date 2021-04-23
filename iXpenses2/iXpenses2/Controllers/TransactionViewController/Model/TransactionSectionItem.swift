//
//  Transaction.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 24.03.2021.
//

import RxDataSources
import UIKit

struct TransactionSectionItem {
    let name: String
    var items: [TransactionRowItem]
}

extension TransactionSectionItem: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return (lhs.name == rhs.name)
    }
}

enum TransactionRowItem {
    case transaction(item: TransactionItem)
    case filter

    public var identity: String {
        switch self {
        case .transaction(let item):
            return "transaction_\(item.id)"
        case .filter:
            return "filter"
        }
    }
}

extension TransactionRowItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .transaction(let item):
            hasher.combine("transaction")
            hasher.combine(item)
        case .filter:
            hasher.combine("filter")
        }
    }
}

extension TransactionRowItem: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return (lhs.hashValue == rhs.hashValue)
    }
}

extension TransactionRowItem: IdentifiableType {}

extension TransactionSectionItem: AnimatableSectionModelType {
    typealias Identity = String

    var identity: String {
        return name
    }

    typealias Item = TransactionRowItem

    init(original: TransactionSectionItem, items: [Item]) {
        self = original
        self.items = items
    }
}
