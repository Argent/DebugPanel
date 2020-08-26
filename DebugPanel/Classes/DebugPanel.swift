//
//  DebugPanel.swift
//
//  Created by Benjamin Otto on 03/02/16.
//  Copyright © 2016 Benjamin Otto. All rights reserved.
//

import Foundation
import UIKit

public class DebugPanel: NSObject {
    private var keyWindow: UIWindow?
    private var debugWindow: UIWindow?
    
    private var providers = [DebugPanelProvider]()
    
    private(set) public static var debugGesture: UIGestureRecognizer?
    
    public init(window: UIWindow) {
        super.init()
        setup(window: window)
    }
    
    deinit {
        keyWindow = nil
        debugWindow?.isHidden = true
        debugWindow = nil
    }
    
    private func setup(window: UIWindow) {
        keyWindow = window
        
        let gestureName = "DebugPanel activation gesture"
        
        for gestureRecognizer in window.gestureRecognizers ?? [] {
            if #available(iOS 11.0, *) {
                if gestureRecognizer.name == gestureName {
                    window.removeGestureRecognizer(gestureRecognizer)
                }
            } else {
                if let longPress = gestureRecognizer as? UILongPressGestureRecognizer {
                    if longPress.minimumPressDuration == 2 && longPress.numberOfTouchesRequired == 2 {
                        window.removeGestureRecognizer(gestureRecognizer)
                    }
                }
            }
        }
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DebugPanel.openDebugPanel))
        if #available(iOS 11.0, *) {
            gestureRecognizer.name = gestureName
        }
        gestureRecognizer.minimumPressDuration = 2
        gestureRecognizer.numberOfTouchesRequired = 2
        window.addGestureRecognizer(gestureRecognizer)
        
        Self.debugGesture = gestureRecognizer
    }
    
    @objc public func openDebugPanel() {
        if debugWindow != nil {
            return
        }
        
        let sections = debugSectionsFromProviders()
        
        debugWindow = UIWindow(frame: UIScreen.main.bounds)
        debugWindow?.windowLevel = UIWindowLevelNormal
        let debugViewController = DebugTableViewController(sections: sections)
        let rootViewController = DebugNavigationController(rootViewController: debugViewController)
        debugWindow?.rootViewController = rootViewController
        
        let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(DebugPanel.closeDebugPanel))
        debugViewController.navigationItem.rightBarButtonItem = closeButton
        
        debugWindow?.makeKeyAndVisible()
    }
    
    @objc public func closeDebugPanel() {
        debugWindow?.isHidden = true
        keyWindow?.makeKeyAndVisible()
        debugWindow = nil
    }
    
    public func registerProvider(provider: DebugPanelProvider) {
        providers.append(provider)
    }
    
    public func unregisterProvider(provider: DebugPanelProvider) {
        guard let index = providers.index(where: { (other: DebugPanelProvider) in other === provider }) else {
            return
        }
        providers.remove(at: index)
    }
    
    func debugSectionsFromProviders() -> [DebugSection] {
        return providers.map({ $0.provideDebugSection() })
    }
}
