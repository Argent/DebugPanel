//
//  BOSelectableTableViewCell.swift
//  DebugPanel
//
//  Created by Benjamin Otto on 05.10.18.
//

import Foundation
import Bohr

class BOSelectableTableViewCell: BOTableViewCell {
    var onSelection: ((UITableViewCell, UITableViewController) -> Void)?
    
    override func wasSelected(from viewController: BOTableViewController!) {
        onSelection?(self, viewController)
    }
}
