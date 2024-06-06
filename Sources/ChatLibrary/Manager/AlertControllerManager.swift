//
// AlertControllerManager.swift
// 
// 
// 

import SwiftUI
import Foundation
import Observation

public class AlertController {
    public let alertTitle: String
    public let alertBodyMessage: String
    public var actions: [AlertAction] = []
    
    private init(title: String, message: String, actions: [AlertAction]) {
        alertTitle = title
        alertBodyMessage = message
        self.actions = actions
    }
    
    public convenience init(alertTitle: String, bodyMessage: String) {
        self.init(title: alertTitle, message: bodyMessage, actions: [])
    }

    public func addAlertAction(titleButton: String, buttonRole: ButtonRole? = nil, handler: (() -> ())? = nil) {
        let alertAction = AlertAction(title: titleButton, action: handler)
        actions.append(alertAction)
    }
    
    public struct AlertAction: Identifiable {
        public var id: String {
            title
        }
        
        public let title: String
        public let buttonRole: ButtonRole?
        public let action: (() -> ())
        
        public init(title: String, action: (() -> ())?) {
            self.init(title: title, buttonRole: nil, action: action)
        }
        
        public init(title: String, buttonRole: ButtonRole?, action: (() -> ())?) {
            self.title = title
            self.buttonRole = buttonRole
            self.action = action ?? {}
        }
    }
}
