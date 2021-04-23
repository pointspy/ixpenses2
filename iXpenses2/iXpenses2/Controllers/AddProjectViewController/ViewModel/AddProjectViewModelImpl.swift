//
//  HomeViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxCocoa
import RxDataSources
import RxSwift

class AddProjectsViewModelImpl: AddProjectsViewModel, AddProjectsViewModelInput, AddProjectsViewModelOutput {
    // MARK: Inputs

    private(set) lazy var doneTrigger = doneAction.inputs
    private(set) lazy var cancelTrigger = cancelAction.inputs

//    // MARK: Actions

    private lazy var doneAction = Action<ProjectItem, Void> { [unowned self] item in

        ProjectsRepository.defaultRepo.add(item: item)

        return self.router.rxTrigger(.dismissCurrent)
    }

    private lazy var cancelAction = CocoaAction { [unowned self] in
        self.router.rxTrigger(.dismissCurrent)
    }

    // MARK: Ouputs

    var addProjectSections: Observable<[AddProjectSection]> {
        let iconSection = AddProjectSection(items: [AddProjectSectionItem.iconSectionItem(projectItem: projectItem)])
        let textFieldSection = AddProjectSection(items: [AddProjectSectionItem.textFieldSectionItem(projectItem: projectItem)])

        let colorsFieldSection = AddProjectSection(items: [AddProjectSectionItem.colorsSectionItem(projectItem: projectItem)])
        let iconCollectionSection = AddProjectSection(items: [AddProjectSectionItem.iconsCollectionSectionItem(projectItem: projectItem)])

        return Observable.just([iconSection, textFieldSection, colorsFieldSection, iconCollectionSection])
    }

    // MARK: Stored properties

    private let router: UnownedRouter<AppRoute>

    // MARK: Initialization

    var projectItem: ProjectItem?

    init(router: UnownedRouter<AppRoute>, projectItem: ProjectItem?) {
        self.router = router
        self.projectItem = projectItem
    }
}
