//
// ChatController.swift
//
//
// 

import Foundation
import Observation

@Observable
open class ChatController: ChatManagering {
    
    public var chatAlert: AlertController?
    public var chatStatus: ChatClientStatus? 
    public var messages: [ChatMessage] = []
    public var showAlert: Bool = false
    public var messageToResend: ChatMessage? = nil
    public var isDisabled: Bool = true
    
    open func removeUnsentMessage(message: ChatMessage) {
        if let index = messages.firstIndex(of: message) {
            messages.remove(at: index)
        }
    }
    
    open func resendMessage(message: ChatMessage) {
        
    }
    
    @MainActor
    open func sendMessage(message: String) async {
        messages.append(ChatClientMessage(message))
    }
    
    
    public init() {
        
    }
    open func start() {
        
    }

    @MainActor
    open func addNewMessage(_ message: ChatMessage) async {
        messages.append(message)
    }
    
    open func end() {
        
    }
    
    @MainActor
    open func userTappedSubmit(params: String...) {
        chatStatus = .inQueue
    }

    open func tappedOnClientError(message: ChatMessage) {
        let alertController = AlertController(alertTitle: "title", bodyMessage: "Test")
        alertController.addAlertAction(titleButton: "OK") {
            self.removeUnsentMessage(message: message)
        }
        chatAlert = alertController
    }
    
    open func userTappedCancelButton() {
        chatStatus = .doingNothing
    }
}
