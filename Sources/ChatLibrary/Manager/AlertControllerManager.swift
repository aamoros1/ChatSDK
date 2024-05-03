//
// AlertControllerManager.swift
// 
// 
// 

import SwiftUI
import Foundation
import Observation

public class AlertController {
    let alertTitle: String
    let alertBodyMessage: String
    var actions: [AlertAction] = []
    
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
        
        let title: String
        let buttonRole: ButtonRole?
        let action: (() -> ())
        
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
