//
// ChatContainerView.swift
// 
//
// 

import SwiftUI
import Observation

@Observable
public class AlertOperation {
    enum Alert {
        case endChat(ok: () -> (), cancel: () -> ())
        
        var message: String {
            switch self {
            case .endChat:
                return String(localized: "Chat.End.Chat", bundle: .module)
            }
        }
        
        var cancelButton: String {
            switch self {
            case .endChat:
                return String(localized: "Cancel", bundle: .module)
            }
        }

        var okButton: String {
            switch self {
            case .endChat:
                return String(localized: "Ok", bundle: .module)
            }
        }
    }

    var alert: Alert? = nil {
        willSet {
            guard alert != nil else { return }
            showAlert = true
        }
    }

    var showAlert: Bool = false
}

@Observable
open class ChatController: ChatManagering {
    public func removeUnsentMessage(message: ChatMessage) {
        if let index = messages.firstIndex(of: message) {
            messages.remove(at: index)
        }
    }
    
    public func resendMessage(message: ChatMessage) {
        
    }
    
    public func sendMessage(message: String) {
        
    }
    
    
    public init() {
        
    }
    public func start() {
        
    }

    @MainActor
    func addNewMessage(_ message: ChatMessage) async {
        messages.append(message)
    }
    
    public func end() {
        
    }
    
    public func userTappedSubmit(withReason: String) {
        
    }
    
    public func tappedOnClientError(message: ChatMessage) {
        
    }
    
    public func sendMessage() {
        
    }
    
    public func userTappedCancelButton() {
        
    }
    public var inputString: String = ""
    
    public var chatStatus: ChatClientStatus = .chatting
     
    public var messages: [ChatMessage] = []
    
    public var showAlert: Bool = false
    
    public var messageToResend: ChatMessage? = nil
    
    
}

public struct ChatContainerView<Controller>: View where Controller: ChatController {
    @State
    var chatController: Controller

    public var body: some View {
        Group {
            switch chatController.chatStatus {
            case .doingNothing:
                ChatSetupView(textInput: $chatController.inputString)
                    .environment(chatController)
            case .requestingChat:
                ChatSetupView(textInput: $chatController.inputString)
                    .environment(chatController)
            case .inQueue:
                ChatInQueueView<Controller>(queueInfo: "")
                    .environment(chatController)
            case .chatting:
                ChatInConversationView<Controller>()
                    .environment(chatController)
            }
        }
        .task {
            chatController.start()
        }
    }
}

struct ChatContainerViewPreviews: PreviewProvider {
    static var previews: some View {
        ChatContainerView(chatController: ChatController.init())
            .preferredColorScheme(.dark)
    }
}
