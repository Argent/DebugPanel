//
//  DebugActionCell.swift
//
//  Created by Benjamin Otto on 11/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import Foundation

public class DebugActionCell: DebugCellType {
    
    let title: String
    let buttonTitle: String
    let action: (() -> Void)
    
    public init(title: String, buttonTitle: String, action: @escaping (() -> Void)) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.action = action
    }
    
    public func keyValue() -> String? {
        return nil
    }
    
    public func valueOverride() -> Any? {
        return nil
    }
}
