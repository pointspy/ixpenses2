//
//  ColorItem.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 22.03.2021.
//

import RxDataSources
import UIKit

struct IconItem {
    let iconName: String
}

struct SectionOfIcons {
    var name: String = "Main"

    var items: [IconItem]

    static var defaultValues: [SectionOfIcons] {
        let items: [IconItem] = SFSymbolHelper.allNames.unique().map { IconItem(iconName: $0) }

        return [SectionOfIcons(items: items)]
    }
}

extension IconItem: Equatable, IdentifiableType {
    public typealias Identity = String

    public var identity: String {
        return iconName
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return (lhs.iconName == rhs.iconName)
    }
}

extension SectionOfIcons: AnimatableSectionModelType {
    typealias Identity = String

    var identity: String {
        return name
    }

    typealias Item = IconItem

    init(original: SectionOfIcons, items: [Item]) {
        self = original
        self.items = items
    }
}
