//
//  DebugOptionCell.swift
//
//  Created by Benjamin Otto on 11/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import Foundation

public class DebugOptionCell: DebugOptionCellType {
    
    let title: String
    let key: String
    let options: [String]
    let override: String?
    let action: ((_ oldValue: String?, _ newValue: String) -> Void)?
    
    public init(title: String, key: String, options: [String], currentValue: String? = nil, action: ((_ oldValue: String?, _ newValue: String) -> Void)? = nil) {
        self.title = title
        self.key = key
        self.options = options
        self.override = currentValue
        self.action = action
    }
    
    public func keyValue() -> String? {
        return key
    }
    
    public func valueOverride() -> Any? {
        return override
    }
}
