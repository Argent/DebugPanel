//
//  DebugSettingCell.swift
//
//  Created by Benjamin Otto on 11/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import Foundation

public class DebugSettingCell<T: DebugPanelType>: DebugCellType {
    
    let title: String
    let key: String
    let override: T?
    let action: ((_ oldValue: T?, _ newValue: T) -> Void)?
    
    public init(title: String, key: String, currentValue: T? = nil, action: ((_ oldValue: T?, _ newValue: T) -> Void)? = nil) {
        self.title = title
        self.key = key
        self.override = currentValue
        self.action = action
    }
    
    public func keyValue() -> String? {
        return key
    }
    
    public func valueOverride() -> Any? {
        if let override = override as? DebugVariant {
            return override.rawValue
        }
        return override
    }
}
