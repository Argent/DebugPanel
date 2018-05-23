//
//  DebugOptionsTableViewController.swift
//
//  Created by Benjamin Otto on 04/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import UIKit
import Bohr

class DebugOptionsTableViewController: BOTableViewController {
    
    private var optionSections: [(title: String, options: DebugPanelPromise<[String]>)]?
    private var key: String?
    
    required init(sections: [(title: String, options: DebugPanelPromise<[String]>)], key: String) {
        super.init(style: .grouped)
        self.optionSections = sections
        self.key = key
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
    
    override func setup() {
        guard let options = optionSections, let _ = key else {
            return
        }
        super.setup()
        
        title = "Debug Panel"
        
        for section in options {
            createSection(title: section.title, options: section.options)
        }
    }
    
    private func createSection(title: String, options promise: DebugPanelPromise<[String]>) {
        let boSection = BOTableViewSection(headerTitle: title ?? "", handler: nil)
        promise.resolvers({ [weak self] options -> Void in
            for option in options {
                self?.createCell(option: option, forSection: boSection!)
            }
            self?.addSection(boSection)
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }) { error -> Void in
            guard let error = error else {
                return
            }
//            DDLogDebug("Could not load debug section '\(title)', error: \(error.description)'")
        }
    }

    private func createCell(option: String, forSection section: BOTableViewSection) {
        let cell = BOStringOptionTableViewCell(title: option, key: key, handler: nil)!
        cell.value = option
        section.addCell(cell)
    }
}
