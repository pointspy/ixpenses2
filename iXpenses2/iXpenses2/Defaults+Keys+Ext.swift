//
//  Defaults+Keys+Ext.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 21.03.2021.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let projects = Key<[ProjectItem]>("projects", default: [])
}
