//
//  ProjectItem.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 21.03.2021.
//

import Codextended
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

public struct ProjectItem: Codable {
    static let empty: ProjectItem = .init(name: "", iconName: "star.fill", colorName: "blue", transactions: [])
    
    enum Colors: String {
        case red
        case blue
        case orange
        case purple
        case green
        case pink
        case blueLight
        case indigo
        case watermelon
        case gray
        case brown
        case yellow
        
        var color: UIColor {
            switch self {
            case .red:
                return UIColor(named: "iRed")!
            case .blue:
                return UIColor(named: "iBlue")!
            case .orange:
                return UIColor(named: "iOrange")!
            case .purple:
                return UIColor(named: "iPurple")!
            case .green:
                return UIColor(named: "iGreen")!
            case .pink:
                return UIColor(named: "iDutyPink")!
            case .blueLight:
                return UIColor(named: "iBlueLight")!
            case .indigo:
                return UIColor(named: "iIndigo")!
            case .watermelon:
                return UIColor(named: "iWatermelon")!
            case .gray:
                return UIColor(named: "iGray")!
            case .brown:
                return UIColor(named: "iBrown")!
            case .yellow:
                return UIColor(named: "iYellow")!
            }
        }
        
        static var allCases: [Colors] = [.blue, .red, .green, .orange, .pink, .purple, .blueLight, .indigo, .brown, .gray, .yellow, .watermelon]
    }
    
    var name: String
    var iconName: String
    var colorName: String
    var transactions: [TransactionItem]
    var id: UUID
    var isArchive: Bool
    
    enum CodingKeys: String, CodingKey {
        case success, iconName, colorName, transactions, id, isArchive
    }
    
    public var transactionsRelay: BehaviorRelay<[TransactionItem]>
    
    var transactionsRowsDriver: Driver<[TransactionRowItem]> {
        self.transactionsRelay.asDriver().flatMapLatest { transactions -> Driver<[TransactionRowItem]> in
            
            let rows = transactions.map { TransactionRowItem.transaction(item: $0) }
            
            return BehaviorRelay<[TransactionRowItem]>.init(value: rows).asDriver()
        }
    }
    
    init(name: String, iconName: String, colorName: String, transactions: [TransactionItem]) {
        self.name = name
        self.iconName = iconName
        self.colorName = colorName
        self.transactions = transactions
        self.id = UUID()
        self.isArchive = false
        self.transactionsRelay = .init(value: self.transactions)
    }
    
    mutating func setTransactions(_ transactions: [TransactionItem]) {
        self.transactions = transactions
        self.transactionsRelay.accept(transactions)
    }
    
    mutating func updateTransaction(_ transaction: TransactionItem) {
        guard let firstI = self.transactions.firstIndex(where: { $0.id == transaction.id }) else { return }
        
        self.transactions[firstI] = transaction
        
        self.transactionsRelay.accept(self.transactions)
    }
    
    mutating func addTransaction(_ transaction: TransactionItem) {
        var newItems = self.transactions
        newItems.append(transaction)
        self.transactions = newItems
        self.transactionsRelay.accept(newItems)
    }
    
    mutating func removeTransaction(_ transaction: TransactionItem) {
        var newItems = self.transactions
        
        newItems.removeAll { item in
            item == transaction
        }
        
        self.transactions = newItems
        
        self.transactionsRelay.accept(newItems)
    }
    
    mutating func removeAllTransactions() {
        self.transactions.removeAll()
        
        self.transactionsRelay.accept(self.transactions)
    }
    
    mutating func setName(_ name: String) {
        self.name = name
    }
    
    mutating func setIconName(_ name: String) {
        self.iconName = name
    }
    
    mutating func setColorName(_ name: String) {
        self.colorName = name
    }
    
    mutating func setArchive(_ value: Bool) {
        self.isArchive = value
    }
    
    var minusSum: Double {
        return self.transactions.filter { !$0.isPlus }.reduce(0.0) { res, item in
            res + item.sum
        }
    }
    
    var plusSum: Double {
        return self.transactions.filter { $0.isPlus }.reduce(0.0) { res, item in
            res + item.sum
        }
    }
    
    var balance: Double {
        return self.plusSum - self.minusSum
    }
    
    public init(from decoder: Decoder) throws {
        self.name = try decoder.decode("name")
        self.id = try decoder.decode("id")
        self.isArchive = try decoder.decode("isArchive")
        self.transactions = try decoder.decode("transactions")
        self.iconName = try decoder.decode("iconName")
        self.colorName = try decoder.decode("colorName")
        self.transactionsRelay = .init(value: self.transactions)
    }
    
    public func encode(to encoder: Encoder) throws {
        try encoder.encode(self.iconName, for: "iconName")
        try encoder.encode(self.colorName, for: "colorName")
        try encoder.encode(self.name, for: "name")
        try encoder.encode(self.transactions, for: "transactions")
        try encoder.encode(self.id, for: "id")
        try encoder.encode(self.isArchive, for: "isArchive")
    }
}

extension ProjectItem {
    var iconColor: UIColor {
        guard let colorItem = ProjectItem.Colors(rawValue: self.colorName) else {
            return .systemBlue
        }
        
        return colorItem.color
    }
}

extension ProjectItem: IdentifiableType {
    public typealias Identity = UUID
    
    public var identity: UUID {
        return self.id
    }
}

extension ProjectItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
        hasher.combine(self.iconName)
        hasher.combine(self.colorName)
        hasher.combine(self.transactions)
        hasher.combine(self.id)
        hasher.combine(self.isArchive)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
