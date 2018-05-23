//
//  DebugSection.swift
//
//  Created by Benjamin Otto on 03/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import Foundation

public class DebugSection: NSObject {
    let cells: [DebugCellType]
    let footerText: String?
    let headerText: String?
    
    public init(withCells cells: [DebugCellType], footerText footer: String? = nil, headerText header: String? = nil) {
        self.cells = cells
        footerText = footer
        headerText = header
        super.init()
    }
}
