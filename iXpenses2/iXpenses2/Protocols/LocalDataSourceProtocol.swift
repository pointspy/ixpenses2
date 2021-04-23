//
//  DataSourceProtocol.swift
//  Shlist
//
//  Created by Pavel Lyskov on 09.04.2020.
//  Copyright © 2020 Pavel Lyskov. All rights reserved.
//

import RxCocoa
import RxSwift

public protocol LocalDataSourceProtocol {
    associatedtype Item
    var items: BehaviorRelay<[Item]> { get }
    func update(item: Item)
    func getItem(withId id: UUID) -> Item?
    func set(items: [Item])
    var allItems: [Item] { get }
    func remove(item: Item)
    func getIndex(for item: Item) -> Int?
}
