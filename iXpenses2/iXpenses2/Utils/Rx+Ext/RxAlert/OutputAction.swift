//
//  OutputAction.swift
//  RxAlert
//
//  Created by Shichimitoucarashi on 2020/02/27.
//  Copyright © 2020 Shichimitoucarashi. All rights reserved.
//

import UIKit

public struct OutputAction {
    public var index: Int
    public var textFields: [UITextField]?
}

extension OutputAction {
    
    static var empty = OutputAction(index: 0, textFields: nil)
    
}
