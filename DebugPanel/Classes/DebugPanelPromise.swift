//
//  DebugPanelPromise.swift
//
//  Created by Benjamin Otto on 24/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import Foundation

public struct DebugPanelPromise<T> {
    let resolvers: (_ success: (T) -> Void, _ failure: (NSError?) -> Void) -> Void
    
    public init(resolvers: @escaping (_ success: (T) -> Void, _ failure: (NSError?) -> Void) -> Void) {
        self.resolvers = resolvers
    }
}
