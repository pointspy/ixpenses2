//
//  ColorItem.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 22.03.2021.
//

import RxDataSources
import UIKit

struct ColorItem {
    let colorName: String
    
    var color: UIColor {
        return ProjectItem.Colors.init(rawValue: self.colorName)!.color
    }
}

struct SectionOfColors {
    var name: String = "Main"
    
    var items: [ColorItem]
    
    static var defaultValues: [SectionOfColors] {
        
        let items: [ColorItem] = ProjectItem.Colors.allCases.map {ColorItem(colorName: $0.rawValue)}
        
        return [SectionOfColors(items: items)]
    }
    
     
}

extension ColorItem: Equatable, IdentifiableType {
    public typealias Identity = String
    
    public var identity: String {
        return colorName
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return (lhs.colorName == rhs.colorName)
    }
}

extension SectionOfColors: AnimatableSectionModelType {
    typealias Identity = String
    
    var identity: String {
        return name
    }
    
    typealias Item = ColorItem
    
    init(original: SectionOfColors, items: [Item]) {
        self = original
        self.items = items
    }
}
