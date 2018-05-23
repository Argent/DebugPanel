//
//  BOStringOptionTableViewCell.swift
//
//  Created by Benjamin Otto on 04/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import Foundation
import Bohr

class BOStringOptionTableViewCell: BOTableViewCell {
    
    /// Setting value when this cell gets selected - cell's row index by default
    private var _value: String?
    var value: String {
        get {
            return _value ?? "\(indexPath.row)"
        }
        set {
            _value = newValue
        }
    }
    
    override func setup() {
        selectionStyle = .default
    }
    
    override func wasSelected(from viewController: BOTableViewController?) {
        setting.value = value as AnyObject
    }
    
    override func settingValueDidChange() {
        let isSelected = (setting.value as? String) == value
        self.accessoryType = isSelected ? .checkmark : .none
    }
}
