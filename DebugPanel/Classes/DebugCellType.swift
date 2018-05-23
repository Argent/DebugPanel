//
//  DebugCell.swift
//
//  Created by Benjamin Otto on 03/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import Foundation

public protocol DebugCellType {
    func keyValue() -> String?
    func valueOverride() -> Any?
}

protocol DebugOptionCellType: DebugCellType {
    var action: ((_ oldValue: String?, _ newValue: String) -> Void)? { get }
}
