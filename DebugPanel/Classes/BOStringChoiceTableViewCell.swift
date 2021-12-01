//
//  BOStringChoiceTableViewCell.swift
//
//  Created by Benjamin Otto on 05/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import Foundation
import UIKit
import Bohr

class BOStringChoiceTableViewCell: BOTableViewCell {
    
    /// An array defining all the options available for the cell.
    var options = [String]()
    
    /// An array defining all the footer titles for each option assigned to the cell.
    var footerTitles = [String]()
    
    override func setup() {
        selectionStyle = .default
    }
    
    override func footerTitle() -> String? {
        guard let currentOption = setting.value as? String, let index = options.firstIndex(of: currentOption), index < footerTitles.count else {
            return nil
        }
        return footerTitles[index]
    }
    
    override func wasSelected(from viewController: BOTableViewController?) {
        if accessoryType == .disclosureIndicator {
            return
        }
        if let currentOption = setting.value as? String,
                       let index = options.firstIndex(of: currentOption), index < options.count {
            setting.value = options[index] as AnyObject
        } else {
            setting.value = options.first as AnyObject
        }
    }
    
    override func settingValueDidChange() {
        detailTextLabel?.text = setting.value as? String
    }
}
