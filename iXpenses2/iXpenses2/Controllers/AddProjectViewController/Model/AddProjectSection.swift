//
//  AddProjectSection.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 22.03.2021.
//

import Foundation
import RxDataSources

struct AddProjectSection {
    
    var items: [AddProjectSectionItem]
}

enum AddProjectSectionItem {
    
    case iconSectionItem(projectItem: ProjectItem?)
    case textFieldSectionItem(projectItem: ProjectItem?)
    case colorsSectionItem(projectItem: ProjectItem?)
    case iconsCollectionSectionItem(projectItem: ProjectItem?)
}

extension AddProjectSection: SectionModelType {
  typealias Item = AddProjectSectionItem

   init(original: AddProjectSection, items: [Item]) {
    self = original
    self.items = items
  }
}
