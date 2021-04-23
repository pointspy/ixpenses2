//  
//  TransactionViewModel.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 24.03.2021.
//


import Action
import RxSwift
import RxCocoa

protocol TransactionViewModelInput {
    //var doneTrigger: AnyObserver<Void> { get }

}

protocol TransactionViewModelOutput {
    // var itemDriver: Driver<Item> { get }
    var transactionSections: Driver<[TransactionSectionItem]> { get }
}

protocol TransactionViewModel {
    var input: TransactionViewModelInput { get }
    var output: TransactionViewModelOutput { get }

    var project: ProjectItem { get set }
}

extension TransactionViewModel where Self: TransactionViewModelInput & TransactionViewModelOutput {
    var input: TransactionViewModelInput { return self }
    var output: TransactionViewModelOutput { return self }
}
