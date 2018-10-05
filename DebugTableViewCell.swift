//
//  DebugTableViewCell.swift
//  Bohr
//
//  Created by Benjamin Otto on 05.10.18.
//

import Foundation
import UIKit

public class DebugTableViewCell: DebugCellType {
    
    let text: String
    let image: UIImage?
    let accessoryIndicator: UITableViewCell.AccessoryType
    let onSelection: ((UITableViewCell, UITableViewController) -> Void)
    
    public init(text: String, image: UIImage? = nil, accesoryIndicator: UITableViewCell.AccessoryType = .none, onSelection: @escaping (UITableViewCell, UITableViewController) -> Void) {
        self.text = text
        self.image = image
        self.accessoryIndicator = accesoryIndicator
        self.onSelection = onSelection
    }
    
    public func keyValue() -> String? {
        return nil
    }
    
    public func valueOverride() -> Any? {
        return nil
    }
}
