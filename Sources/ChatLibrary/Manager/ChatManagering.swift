//
// ChatManagering.swift
//
// 
// 

import Foundation
import Observation

public enum ChatClientStatus {
    case doingNothing
    case requestingChat
    case inQueue
    case chatting
}

protocol ChatManagering: AnyObject, Observable {
    func start()
    func end()
    func userTappedSubmit(withReason: String)
    func tappedOnClientError(message: ChatMessage)
    func sendMessage(message: String)
    func removeUnsentMessage(message: ChatMessage)
    func resendMessage(message: ChatMessage)
    func userTappedCancelButton()
    var inputString: String { get set }
    var chatStatus: ChatClientStatus { get }
    var messages: [ChatMessage] { get }
    var showAlert: Bool { get }
    var messageToResend: ChatMessage? { get }
}
