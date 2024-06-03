//
// ChatContainerView.swift
// 
//
// 

import SwiftUI
import Observation

public struct ChatContainerView<Controller, Container>: View where Controller: ChatController, Container: View {
    @State
    public var chatController: Controller
    @State var navigationPath: NavigationPath = .init()
    @State var inputString: String = ""
    private let content: () -> Container

    public init(chatController: Controller, @ViewBuilder container: @escaping () -> Container) {
        self.content = container
        _chatController = State(wrappedValue: chatController)
    }
    
    public var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                content()
                Button {
                    chatController.userTappedSubmit(params: inputString)
                } label: {
                    Text(String(localized: "ChatSetupChatAboutCell.Submit", bundle: .module))
                }
                .disabled(chatController.isDisabled)
            }
            .navigationDestination(for: ChatClientStatus.self) { path in
                switch path {
                case .inQueue, .requestingChat:
                    ChatInQueueView(queueInfo: "")
                case .chatting:
                    ChatInConversationView<Controller>()
                        .environment(chatController)
                default:
                    Text("u shouln't see this \(String(describing: path))")
                }
            }
            .onChange(of: chatController.chatStatus) {
                print(chatController.chatStatus)
                switch chatController.chatStatus {
                case .doingNothing:
                    if !navigationPath.isEmpty {
                        while !navigationPath.isEmpty { navigationPath.removeLast() }
                    }
                case .requestingChat, .inQueue:
                    if !navigationPath.isEmpty {
                        while !navigationPath.isEmpty { navigationPath.removeLast() }
                    }
                    navigationPath.append(ChatClientStatus.inQueue)
                case .chatting:
                    if !navigationPath.isEmpty {
                        while !navigationPath.isEmpty { navigationPath.removeLast() }
                    }
                    navigationPath.append(ChatClientStatus.chatting)
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
}
