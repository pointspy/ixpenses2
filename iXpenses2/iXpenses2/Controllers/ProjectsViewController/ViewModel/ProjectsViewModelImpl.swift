//
//  HomeViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift

class ProjectsViewModelImpl: ProjectsViewModel, ProjectsViewModelInput, ProjectsViewModelOutput {
    // MARK: Inputs

    private(set) lazy var addProjectTrigger = addProjectAction.inputs
    private(set) lazy var projectDetailTrigger: AnyObserver<ProjectItem> = projectDetailAction.inputs

//    // MARK: Actions
//
    private lazy var addProjectAction = CocoaAction { [unowned self] in
        self.router.rxTrigger(.addProject(projectItem: nil))
    }

    private lazy var projectDetailAction = Action<ProjectItem, Void> { [unowned self] item in

        self.router.rxTrigger(.projectDetail(projectItem: item))
    }

//
//    private lazy var usersAction = CocoaAction { [unowned self] in
//        self.router.rx.trigger(.users)
//    }
//
//    private lazy var aboutAction = CocoaAction { [unowned self] in
//        self.router.rx.trigger(.about)
//    }

    // MARK: Ouputs

    var projectSections: Observable<[SectionOfProjects]> {
        ProjectsRepository.defaultRepo.items.asObservable()
            .flatMapLatest { (projects: [ProjectItem]) -> Observable<[SectionOfProjects]> in

                let section = SectionOfProjects(name: "main", items: projects)

                return Observable.just([section])
            }
    }

    // MARK: Stored properties

    let router: UnownedRouter<AppRoute>

    // MARK: Initialization

    init(router: UnownedRouter<AppRoute>) {
        self.router = router
    }

    // MARK: Methods

//    func registerPeek(for sourceView: Container) {
//        router.trigger(.registerUsersPeek(from: sourceView))
//    }
}
