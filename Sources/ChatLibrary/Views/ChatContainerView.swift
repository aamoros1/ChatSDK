//
// ChatContainerView.swift
//
//
//

import SwiftUI
import Observation

public struct ChatContainerView<Controller, Container>: View where Controller: ChatController, Container: View {
    @Bindable var chatController: Controller
    @State var inputString: String = ""
    private let content: () -> Container
    @Environment(\.dismiss) var dismiss
    
    public init(
        chatController: Controller,
        @ViewBuilder container: @escaping () -> Container)
    {
        self.content = container
        self.chatController = chatController
    }
    
    public var body: some View {
        VStack {
            content()
            Button {
                chatController.userTappedSubmit(params: inputString)
            } label: {
                Text(String(localized: "ChatSetupChatAboutCell.Submit", bundle: .module))
            }
            .disabled(chatController.isDisabled)
        }
        .fullScreenCover(item: $chatController.chatStatus) { status in
            NavigationStack {
                switch status {
                    case .inQueue, .requestingChat:
                        ChatInQueueView<Controller>(queueInfo: "")
                    case .chatting:
                        ChatInConversationView<Controller>()
                    default:
                        Text("u shouln't see this \(String(describing: status))")
                            .task {
                                dismiss.callAsFunction()
                            }
                }
            }
        }
        .environment(chatController)
        .onAppear {
            chatController.start()
        }
        .onDisappear{
            chatController.end()
        }
    }
}
