//
// ChatContainerView.swift
// 
// Created by Alwin Amoros on 9/9/23.
// 

import SwiftUI


class AlertOperation: ObservableObject {
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

    @Published
    var alert: Alert? = nil {
        willSet {
            guard alert != nil else { return }
            showAlert = true
        }
    }
    @Published
    var showAlert: Bool = false
}

public struct ChatContainerView: View {
    @StateObject
    var viewModel = ChatViewModel()
    @StateObject
    var alertManager = AlertControllerManager()

    public var body: some View {
        NavigationStack(path: $viewModel.path) {
            ChatSetupView(textInput: $viewModel.messageToSend)
                .navigationDestination(for: ChatNavigationStack.self) { state in
                    switch state {
                    case .inQueue:
                        ChatInQueueView(queueInfo: "todo")
                    case .inChat:
                        ChatInConversationView()
                    }
                }
                .onChange(of: viewModel.path) { newValue in
                    viewModel.populateWithMockMessage()
                }
                .alert(alertManager.alertController?.alertTitle ?? "title not set",
                       isPresented: $alertManager.showAlert,
                       presenting: alertManager.alertController) { alertController in
                    ForEach(alertController.actions) { action in
                        Button(action.title,
                               role: action.buttonRole,
                               action: action.action ?? {})
                    }


                } message: { alertMessage in
                    Text(alertMessage.alertBodyMessage)
                }
        }
        .environmentObject(viewModel)
        .environmentObject(alertManager)
    }
}

struct ChatContainerViewPreviews: PreviewProvider {
    static var previews: some View {
        ChatContainerView()
            .preferredColorScheme(.dark)
    }
}
