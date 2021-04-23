//
//  ProductDataSource.swift
//  Shlist
//
//  Created by Pavel Lyskov on 09.04.2020.
//  Copyright © 2020 Pavel Lyskov. All rights reserved.
//

import Defaults
import RxCocoa
import RxSwift

public final class ProjectsDataSource: LocalDataSourceProtocol {
    public typealias Item = ProjectItem
    
    public var allItems: [Item] {
        return localItems
    }
    
    private var localItems: [Item] = []
    private let updatedRelay: BehaviorRelay<[Item]> = .init(value: [])
    
    public var items: BehaviorRelay<[Item]> {
        return updatedRelay
    }
    
    public func update(item: Item) {
        guard let index = localItems.firstIndex(where: { $0.id == item.id }) else { return }
        localItems[index] = item
        
        updatedRelay.accept(localItems)
    }
    
    public func add(item: Item) {
        localItems.append(item)
        
        updatedRelay.accept(localItems)
    }
    
    public func getItem(withId id: UUID) -> Item? {
        guard let index = localItems.firstIndex(where: { $0.id == id }) else { return nil }
        return localItems[index]
    }
    
    public func set(items: [Item]) {
        localItems = items
        
        updatedRelay.accept(items)
    }
    
    public func remove(item: Item) {
        localItems.removeAll { project in
            item.id == project.id
        }
        
        updatedRelay.accept(localItems)
    }
    
    public func getIndex(for item: Item) -> Int? {
        return localItems.firstIndex(of: item)
    }
}

public extension ProjectsDataSource {
    func removeAll() {
        localItems.removeAll()
        updatedRelay.accept([])
    }
}


