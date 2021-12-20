//
//  BOSegmentTableViewCell.swift
//
//  Created by Benjamin Otto on 04/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import UIKit
import Bohr

class BOSegmentTableViewCell: BOTableViewCell {
    
    weak var segmentView: UISegmentedControl!
    
    override func setup() {
        let values = DebugVariant.allValues.map({ $0.rawValue })
        let segmentView = UISegmentedControl(items: values)
        segmentView.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        segmentView.frame = CGRect(x: 0, y: 0, width: 100, height: segmentView.intrinsicContentSize.height)
        accessoryView = segmentView
        self.segmentView = segmentView
    }
    
    override func updateAppearance() {
        segmentView.tintColor = secondaryColor ?? UIColor(red: 0.2577, green: 0.832, blue: 0.3158, alpha: 1.0)
    }
    
    @objc func segmentValueDidChange(_ segmentView: UISegmentedControl) {
        setting.value = DebugVariant.allValues[segmentView.selectedSegmentIndex].rawValue as AnyObject
    }
    
    override func settingValueDidChange() {
        guard let value = (setting.value as? String),
              let enumValue = DebugVariant(rawValue: value),
                  let index = DebugVariant.allValues.firstIndex(of: enumValue) else {
            return
        }
        segmentView.selectedSegmentIndex = index
    }
}
