//
// AlertControllerManager.swift
// 
// 
// 

import SwiftUI
import Foundation
import Observation

@Observable
final public class AlertControllerManager {
    var alertController: AlertController? = nil 
    var showAlert: Bool = false
    
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
    
    public struct AlertController {
        let alertTitle: String
        let alertBodyMessage: String
        var actions: [AlertAction] = []
        
        private init(title: String, message: String, actions: [AlertAction]) {
            alertTitle = title
            alertBodyMessage = message
            self.actions = actions
        }
        
        init(alertTitle: String, bodyMessage: String) {
            self.init(title: alertTitle, message: bodyMessage, actions: [])
        }

        mutating func addAlertAction(titleButton: String, buttonRole: ButtonRole? = nil, handler: (() -> ())? = nil) {
            let alertAction = AlertAction(title: titleButton, action: handler)
            actions.append(alertAction)
        }
    }

    func addAlertController(alertController: AlertController) {
        self.alertController = alertController
    }
    
}
