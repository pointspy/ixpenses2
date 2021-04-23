//
//  ProductRepository.swift
//  Shlist
//
//  Created by Pavel Lyskov on 09.04.2020.
//  Copyright © 2020 Pavel Lyskov. All rights reserved.
//

import Action
import RxCocoa
import RxSwift

final class ProjectsRepository {
    private let localDS: ProjectsDataSource
    typealias Item = ProjectItem
    
    init(localDS: ProjectsDataSource) {
        self.localDS = localDS
    }
    
    public var items: BehaviorRelay<[Item]> {
        return localDS.items
    }
    
    public func update(item: Item) {
        localDS.update(item: item)
    }
    
    public func getItem(withID id: UUID) -> Item? {
        return localDS.getItem(withId: id)
    }
    
    public func set(items: [Item]) {
        localDS.set(items: items)
    }
    
    var allItems: [Item] {
        return localDS.allItems
    }
    
    func remove(item: Item) {
        localDS.remove(item: item)
    }
    
    func removeAll() {
        localDS.removeAll()
    }
    
    func add(item: Item) {
        localDS.add(item: item)
    }
    
    static var defaultRepo = ProjectsRepository(localDS: ProjectsDataSource())
}

extension ProjectsRepository {
    func addTransaction(_ item: TransactionItem, to project: ProjectItem) {
        var newProject = project
        newProject.addTransaction(item)
        update(item: newProject)
    }
    
    func removeTransaction(_ item: TransactionItem, in project: ProjectItem) {
        var newProject = project
        newProject.removeTransaction(item)
        update(item: newProject)
    }
    
    func setTransactions(_ items: [TransactionItem], in project: ProjectItem) {
        var newProject = project
        newProject.setTransactions(items)
        update(item: newProject)
    }
    
    func removeAllTransactions(in project: ProjectItem) {
        var newProject = project
        newProject.removeAllTransactions()
        update(item: newProject)
    }
    
    func updateTransaction(_ item: TransactionItem, in project: ProjectItem) {
        var newProject = project
        newProject.updateTransaction(item)
        update(item: newProject)
    }
}
