//
// ChatManagering.swift
//
// 
// 

import Foundation
import Observation

public enum ChatClientUserActions {
    case userTappedMessageError(AlertController)
    case userTapped
}

public enum ChatClientStatus: String, Identifiable {
    public var id: String {
        rawValue
    }
    
    case doingNothing
    case requestingChat
    case inQueue
    case chatting
}

protocol ChatManagering: AnyObject, Observable {
    func start()
    func end()
    func userTappedSubmit(params: String...)
    func tappedOnClientError(message: ChatMessage)
    func sendMessage(message: String) async
    func removeUnsentMessage(message: ChatMessage)
    func resendMessage(message: ChatMessage)
    func userTappedCancelButton()
    var chatStatus: ChatClientStatus? { get }
    var messages: [ChatMessage] { get }
    var showAlert: Bool { get }
    var messageToResend: ChatMessage? { get }
    var chatAlert: AlertController? { get }
    var isDisabled: Bool { get }
}
