//  
//  HomeViewModel.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift

protocol ProjectsViewModelInput {
    var addProjectTrigger: AnyObserver<Void> { get }
    var projectDetailTrigger: AnyObserver<ProjectItem> { get }
}

protocol ProjectsViewModelOutput {
    var projectSections: Observable<[SectionOfProjects]> { get }
    
}

protocol ProjectsViewModel {
    var input: ProjectsViewModelInput { get }
    var output: ProjectsViewModelOutput { get }

    var router: UnownedRouter<AppRoute> { get }
}

extension ProjectsViewModel where Self: ProjectsViewModelInput & ProjectsViewModelOutput {
    var input: ProjectsViewModelInput { return self }
    var output: ProjectsViewModelOutput { return self }
}
