//
//  TransactionItem.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 21.03.2021.
//

import Foundation
import RxDataSources

public struct TransactionItem: Codable {
    let id: UUID
    let isPlus: Bool
    let name: String
    let sum: Double
    let date: Date
    
    init(isPlus: Bool, name: String, sum: Double, date: Date) {
        self.id = UUID()
        self.isPlus = isPlus
        self.name = name
        self.sum = sum
        self.date = date
    }
    
    
    
    static func generateItems(with count: Int) -> [Self] {
        var result: [TransactionItem] = []
        
        let randWordCount = Int.random(in: 1...5)
        
        for i in 1...count {
            
            result.append(TransactionItem(isPlus: Bool.random(), name: "\(Lorem.words(randWordCount).capitalizingFirstLetter()) \(i)", sum: Double.random(in: 500...50000), date: Date()))
        }
        
        return result
    }
}

extension TransactionItem: IdentifiableType {
    public typealias Identity = UUID
    
    public var identity: UUID {
        return id
    }
}

extension TransactionItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(isPlus)
        hasher.combine(name)
        hasher.combine(sum)
        hasher.combine(date)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension TransactionItem {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy hh:mm"
        return formatter
    }()
}
