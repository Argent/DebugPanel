//
//  BOActionTableViewCell.swift
//
//  Created by Benjamin Otto on 08/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import Foundation
import Bohr

class BOActionTableViewCell: BOTableViewCell {
    
    private weak var button: UIButton?
    
    var buttonTitle: String? {
        didSet {
            guard let buttonTitle = buttonTitle else {
                return
            }
            button?.setTitle(buttonTitle, for: .normal)
        }
    }
    var actionBlock: ((UITableViewCell) -> Void)?
    
    override func setup() {
        super.setup()
        
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(BOActionTableViewCell.buttonPressed(_:)), for: .touchUpInside)
        contentView.addSubview(button)
        button.layer.cornerRadius = 4
        
        let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: button.superview, attribute: .top, multiplier: 1, constant: 5)
        let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: button.superview, attribute: .bottom, multiplier: 1, constant: -5)
        let rightConstraint = NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: button.superview, attribute: .trailing, multiplier: 1, constant: -20)
        let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.superview?.addConstraints([topConstraint, bottomConstraint, rightConstraint, widthConstraint])
        
        self.button = button
    }
    
    @objc func buttonPressed(_ button: UIButton) {
        actionBlock?(self)
    }
    
    override func updateAppearance() {
        super.updateAppearance()
        
        button?.setTitleColor(backgroundColor, for: .normal)
        button?.backgroundColor = secondaryColor ?? UIColor(red: 0.2577, green: 0.832, blue: 0.3158, alpha: 1.0)
    }
}
