//  
//  HomeViewModel.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import RxCocoa

protocol AddProjectsViewModelInput {
    var projectItem: ProjectItem? { get }
    var doneTrigger: AnyObserver<ProjectItem> { get }
    var cancelTrigger: AnyObserver<Void> { get }
//    var usersTrigger: AnyObserver<Void> { get }
//    var aboutTrigger: AnyObserver<Void> { get }
}

protocol AddProjectsViewModelOutput {
    
    var addProjectSections: Observable<[AddProjectSection]> { get }
}

protocol AddProjectsViewModel {
    var input: AddProjectsViewModelInput { get }
    var output: AddProjectsViewModelOutput { get }

    
}

extension AddProjectsViewModel where Self: AddProjectsViewModelInput & AddProjectsViewModelOutput {
    var input: AddProjectsViewModelInput { return self }
    var output: AddProjectsViewModelOutput { return self }
}
