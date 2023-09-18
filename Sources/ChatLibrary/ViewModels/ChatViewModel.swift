//
// ChatViewModel.swift
// 
// Created by Alwin Amoros on 9/9/23.
// 

import Foundation
import SwiftUI

enum ChatNavigationStack {
    case inChat
    case inQueue
}

open class ChatViewModel: ObservableObject {

    enum ChatServiceState: Identifiable {
        case inChat
        case inQueue
        case nothing
        case requestingChat
        
        var id: Int {
            switch self {
            case .nothing:
                return hashValue
            case .inChat:
                return hashValue
            case .inQueue:
                return hashValue
            case .requestingChat:
                return hashValue
            }
        }
    }
    
    @Published var messages: [ChatMessage] = []
    @Published var messageToSend: String = ""
    @Published var showAlert: Bool = false
    @Published var messageToResend: ChatMessage? = nil
    @Published var path = NavigationPath()
    @ObservedObject
    var alertOoperation = AlertOperation()
    
    public init() {
    }

    @MainActor
    func addNewMessage(_ message: ChatMessage) async {
        if let message = message as? ChatClientMessage {
            withAnimation {
                messages.append(message)

            }
        } else if let message = message as? ChatRemoteMessage {
            withAnimation(.linear(duration: 2)) {
                messages.append(message)
                
            }
        }
    }

    func tappedOnClientError(_ message: ChatMessage) {
        guard
            let clientMessage = message as? ChatClientMessage,
            !clientMessage.didSend, !clientMessage.inTransit
        else {
            return
        }
        showAlert = true
        messageToResend = message
    }

    func resendMessage(_ message: ChatMessage) async {
        messageToResend = message
    }

    @MainActor
    func removeUnsentMessage(_ message: ChatMessage) {
        showAlert = false
        guard
            let index = messages.firstIndex(where: { $0.uuid == message.uuid})
        else {
            return
        }
        withAnimation {
            _ = messages.remove(at: index)
        }
    }

    @MainActor
    func sendMessage() {
        let message = ChatClientMessage(messageToSend)
        messageToSend = ""
        messages.append(message)
    }

    func didTapCancel() {
        path.removeLast()
    }

    @MainActor
    func userTappedCancelButton() {
        alertOoperation.alert = .endChat(ok: {
            self.path.removeLast()
        }, cancel: {
            
        })
    }
}
