//
// ChatController.swift
//
//
// 

import Foundation
import Observation

@Observable
open class ChatController: ChatManagering {

    public var chatStatus: ChatClientStatus = .doingNothing
    public var messages: [ChatMessage] = []
    public var showAlert: Bool = false
    public var messageToResend: ChatMessage? = nil
    
    open func removeUnsentMessage(message: ChatMessage) {
        if let index = messages.firstIndex(of: message) {
            messages.remove(at: index)
        }
    }
    
    open func resendMessage(message: ChatMessage) {
        
    }
    
    @MainActor
    open func sendMessage(message: ChatClientMessage) async {
        messages.append(message)
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
        
    }
    
    open func tappedOnClientError(message: ChatMessage) {
        messageToResend = message
    }
    
    open func userTappedCancelButton() {
        
    }
}
