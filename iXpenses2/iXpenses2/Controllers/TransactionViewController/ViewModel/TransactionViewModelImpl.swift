//  
//  TransactionViewModelImpl.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 24.03.2021.
//


import Action
import RxSwift
import RxCocoa

final class TransactionViewModelImpl: TransactionViewModel, TransactionViewModelInput, TransactionViewModelOutput {
    
    // MARK: Inputs

    // private(set) lazy var doneTrigger = doneAction.inputs


//    // MARK: Actions

    // private lazy var doneAction = Action<ProjectItem, ProjectItem> { [unowned self] item in
        

    //     return Observable.just(item)
    // }
//


    // MARK: Ouputs
    
//    var transactionsDriver: Driver<[TransactionItem]> {
//
//        let projectsDriver: Driver<[ProjectItem]> = ProjectsRepository.defaultRepo.items.asDriver()
//
//        let currentProjectDriver: Driver<ProjectItem> = BehaviorRelay<ProjectItem>.init(value: self.project).asDriver()
//
//        return Driver.combineLatest(projectsDriver, currentProjectDriver)
//            .flatMapLatest {pro
//
//            }
//
//    }
    
    

    var transactionSections: Driver<[TransactionSectionItem]> {
        
        return self.project.transactionsRowsDriver
            .distinctUntilChanged()
            .flatMapLatest {rowItems -> Driver<[TransactionSectionItem]> in
                let section = TransactionSectionItem(name: "main", items: rowItems)
                
                return BehaviorRelay<[TransactionSectionItem]>.init(value: [section]).asDriver()
            }
    }

    // MARK: Stored properties

    private let router: UnownedRouter<AppRoute>

    // MARK: Initialization
    
    var project: ProjectItem

    init(router: UnownedRouter<AppRoute>, project: ProjectItem) {
        self.router = router
        self.project = project
    }

    // MARK: Methods


}
