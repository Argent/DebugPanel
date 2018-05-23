//
//  DebugPanelProvider.swift
//
//  Created by Benjamin Otto on 03/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import Foundation

public protocol DebugPanelProvider: class {
    func provideDebugSection() -> DebugSection
}
