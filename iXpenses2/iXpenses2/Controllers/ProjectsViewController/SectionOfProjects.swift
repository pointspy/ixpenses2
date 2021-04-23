//
//  File.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 21.03.2021.
//

import UIKit
import RxDataSources

struct SectionOfProjects {
    var name: String
    var items: [ProjectItem]
    
}

extension SectionOfProjects: AnimatableSectionModelType {
    typealias Identity = String
    
    var identity: String {
        return name
    }
    
    typealias Item = ProjectItem
    
    init(original: SectionOfProjects, items: [Item]) {
        self = original
        self.items = items
    }
}


