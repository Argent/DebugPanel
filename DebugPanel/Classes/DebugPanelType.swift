//
//  DebugPanelType.swift
//
//  Created by Benjamin Otto on 03/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import Foundation

/// This protocol is used to constrain the possible types that can be used for the generic DebugSettingCell
public protocol DebugPanelType: Equatable {}

/// This enum represents a type with two values (A, B) that can be used to visualize the state of an A/B test
public enum DebugVariant: String {
    // swiftlint:disable:next type_name
    case A, B
    static let allValues = [A, B]
}

extension DebugVariant : Equatable {}

public func == (lhs: DebugVariant, rhs: DebugVariant) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

// The types that can be used for the DebugSettingCell:
extension String: DebugPanelType {}
extension Bool: DebugPanelType {}
extension DebugVariant: DebugPanelType {}
