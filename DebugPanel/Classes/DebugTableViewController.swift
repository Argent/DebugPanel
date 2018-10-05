//
//  DebugTableViewController.swift
//
//  Created by Benjamin Otto on 03/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import Foundation
import UIKit
import Bohr

class DebugTableViewController: BOTableViewController {
    
    private var debugSections: [DebugSection]?
    
    required init(sections: [DebugSection]) {
        super.init(style: .grouped)
        debugSections = sections
        setup()
    }
    
    // Details on why this has to be implemented:
    // http://petersteinberger.com/blog/2015/uitableviewcontroller-designated-initializer-woes/
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        guard let debugSections = debugSections else {
            return
        }
        for key in debugSections.flatMap({ $0.cells }).flatMap({ $0.keyValue() }) {
            UserDefaults.standard.removeObserver(self, forKeyPath: key)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let debugSections = debugSections, let keyPath = keyPath, let change = change, let oldValue = change[.oldKey], let newValue = change[.newKey] else {
            return
        }
        for cell in debugSections.flatMap({ $0.cells }).filter({ $0.keyValue() == keyPath}) {
            switch cell {
            case is DebugSettingCell<Bool>:
                notifyCellForNewValue(cell: cell as? DebugSettingCell<Bool>, newValue: newValue as AnyObject, oldValue: oldValue as AnyObject)
            case is DebugSettingCell<String>:
                notifyCellForNewValue(cell: cell as? DebugSettingCell<String>, newValue: newValue as AnyObject as AnyObject, oldValue: oldValue as AnyObject)
            case is DebugSettingCell<DebugVariant>:
                notifyDebugVariantCellForNewValue(cell: cell as? DebugSettingCell<DebugVariant>, newValue: newValue as AnyObject, oldValue: oldValue as AnyObject)
            case is DebugOptionCellType:
                notifyDebugCellTypeForNewValue(cell: cell, newValue: newValue as AnyObject, oldValue: oldValue as AnyObject)
            default:
                break
            }
        }
        
//        DDLogDebug("Changed key: '\(keyPath)' from: '\(oldValue)' to: '\(newValue)'")
    }
    
    private func notifyCellForNewValue<T: Equatable>(cell: DebugSettingCell<T>?, newValue: AnyObject, oldValue: AnyObject) {
        if let cell = cell, let newValue = newValue as? T, (oldValue as? T) != newValue {
            cell.action?(oldValue as? T, newValue)
        }
    }
    
    private func notifyDebugVariantCellForNewValue(cell: DebugSettingCell<DebugVariant>?, newValue: AnyObject?, oldValue: AnyObject?) {
        if let cell = cell, let newValue = DebugVariant(rawValue: newValue as? String ?? ""), DebugVariant(rawValue: oldValue as? String ?? "") != newValue {
            cell.action?(DebugVariant(rawValue: oldValue as? String ?? ""), newValue)
        }
    }
    
    private func notifyDebugCellTypeForNewValue(cell: DebugCellType, newValue: AnyObject?, oldValue: AnyObject?) {
        if let cell = cell as? DebugOptionCellType, let newValue = newValue as? String, (oldValue as? String)  != newValue {
            cell.action?(oldValue as? String, newValue)
        }
    }
    
    override func setup() {
        guard let debugSections = debugSections else {
            return
        }
        super.setup()
        
        title = "Debug Panel"
        
        for section in debugSections {
            let tableViewSection = createSection(section)
            for cell in section.cells {
                createCell(cell, forSection: tableViewSection)
            }
        }
    }
    
    private func createSection(_ section: DebugSection) -> BOTableViewSection {
        let boSection = BOTableViewSection(headerTitle: section.headerText ?? "", handler: nil)!
        boSection.footerTitle = section.footerText
        addSection(boSection)
        return boSection
    }
    
    private func createCell(_ cell: DebugCellType, forSection section: BOTableViewSection) {
        var tableCell: BOTableViewCell?
        switch cell {
        case let cell as DebugSettingCell<Bool>:
            tableCell = BOSwitchTableViewCell(title: cell.title, key: cell.key)
        case let cell as DebugSettingCell<String>:
            tableCell = BOTextTableViewCell(title: cell.title, key: cell.key)
            if let textField = (tableCell as? BOTextTableViewCell)?.textField {
                textField.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2, height: textField.intrinsicContentSize.height)
            }
        case let cell as DebugSettingCell<DebugVariant>:
            tableCell = BOSegmentTableViewCell(title: cell.title, key: cell.key)
        case let cell as DebugOptionCell:
            tableCell = BOStringChoiceTableViewCell(title: cell.title, key: cell.key, handler: { boCell in
                (boCell as? BOStringChoiceTableViewCell)?.options = cell.options
                let promise = DebugPanelPromise<[String]>(resolvers: { success, failure in
                    success(cell.options)
                })
                (boCell as? BOStringChoiceTableViewCell)?.destinationViewController = DebugOptionsTableViewController(sections: [(cell.title, promise)], key: cell.key)
            })
        case let cell as DebugActionCell:
            tableCell = BOActionTableViewCell(title: cell.title, key: nil, handler: { boCell in
                (boCell as? BOActionTableViewCell)?.actionBlock = cell.action
                (boCell as? BOActionTableViewCell)?.buttonTitle = cell.buttonTitle
            })
        case let cell as AsyncDebugOptionCell:
            tableCell = BOStringChoiceTableViewCell(title: cell.title, key: cell.key, handler: { boCell in
                (boCell as? BOStringChoiceTableViewCell)?.destinationViewController = DebugOptionsTableViewController(sections: cell.sections, key: cell.key)
            })
        case let cell as DebugTableViewCell:
            tableCell = BOSelectableTableViewCell(title: cell.text, key: nil, handler: { boCell in
                (boCell as? BOSelectableTableViewCell)?.imageView?.image = cell.image
                (boCell as? BOSelectableTableViewCell)?.accessoryType = cell.accessoryIndicator
                (boCell as? BOSelectableTableViewCell)?.onSelection = cell.onSelection
            })
        default:
            return
        }
        
        if let override = cell.valueOverride() {
            tableCell?.setting.value = override as AnyObject
        }
        
        if let tableCell = tableCell {
            section.addCell(tableCell)
        }
        
        if let key = cell.keyValue() {
            UserDefaults.standard.addObserver(self, forKeyPath: key, options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old], context: nil)
        }
    }
}

extension BOTableViewCell {
    convenience init(title: String, key: String) {
        self.init(title: title, key: key, handler: nil)
    }
}
