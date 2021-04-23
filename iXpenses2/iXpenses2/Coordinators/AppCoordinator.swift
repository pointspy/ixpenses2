//
//  AppCoordinator.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

enum AppRoute: Route {
    case home
    case addProject(projectItem: ProjectItem?)
    case dismissCurrent
    case popCurrent
    case projectDetail(projectItem: ProjectItem)
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    
    func configureUIAppearance() {
        let appearance = UINavigationBar.appearance()
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label
        ]

        appearance.tintColor = .label
        appearance.prefersLargeTitles = true
        appearance.isTranslucent = true
        appearance.titleTextAttributes = titleTextAttributes
        appearance.largeTitleTextAttributes = titleTextAttributes
    }
    
    // MARK: Initialization

    init() {
        super.init(initialRoute: .home)
    }

    // MARK: Overrides

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .home:
            configureUIAppearance()
            let viewController = ProjectsViewController()
            viewController.loadViewIfNeeded()
            let viewModel = ProjectsViewModelImpl(router: unownedRouter)
            viewController.bind(to: viewModel)
            viewController.navigationItem.largeTitleDisplayMode = .automatic
            return .push(viewController)
        case .addProject(let projectItem):

            
            let viewController = AddProjectViewController.instantiate()
            let viewModel = AddProjectsViewModelImpl(router: unownedRouter, projectItem: projectItem)
            
            let nvc = UINavigationController(rootViewController: viewController)
            
            viewController.bind(to: viewModel)
            
            return .present(nvc)
        case .dismissCurrent:
            return .dismiss()
        case .popCurrent:
            return .pop()
        case .projectDetail(let projectItem):
            
            let viewController = TransactionViewController(style: .insetGrouped)
            let viewModel = TransactionViewModelImpl(router: unownedRouter, project: projectItem)
            viewController.bind(to: viewModel)
            return .push(viewController)
        }
    }

    // MARK: Methods
}
