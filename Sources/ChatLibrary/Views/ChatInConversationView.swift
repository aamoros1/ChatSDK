//
// ChatInConversationView.swift
//
// 
//

import SwiftUI
import Foundation

struct ChatInConversationView<Controller>: View where Controller: ChatController {
    
    private struct LocalizedString {
        static var tryAgainButton: String {
            String(localized: "Try.Again",
                   bundle: .module)
        }
        static var alertTitle: String {
            String(localized: "ChatInConversationView.Alert.Title",
                   bundle: .module)
        }
        static var cancelButton: String {
            String(localized: "Cancel",
                   bundle: .module)
        }
        static var removeButton: String {
            String(localized: "ChatInConversationView.Alert.Remove",
                   bundle: .module)
        }
    }
    
    @Environment(Controller.self) var chatController
    @State
    var messageToSend: String = "hi"
    @State var showAlert: Bool = false

    private var toSendMessage: ChatClientMessage {
        .init(messageToSend)
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(chatController.messages, id: \.uuid) { message in
                        cellForRow(message: message)
                    }
                }
                .onChange(of: chatController.messages, initial: false) { oldValue, newValue in
                    proxy.scrollTo(newValue.last?.uuid)
                }
                inputContainerView
            }
        }
        .navigationTitle("Chat")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    chatController.userTappedCancelButton()
                }
            }
        }
    }
}

extension ChatInConversationView {
    @ViewBuilder
    private func cellForRow(message: ChatMessage) -> some View{
        switch type(of: message) {
        case is ChatClientMessage.Type:
            let message = message as! ChatClientMessage
            ChatClientMessageCell(message: message) {
                chatController.showAlert = true
                let alert = AlertController(
                    alertTitle: "Warning",
                    bodyMessage: "Would you like to resend the message or delete?"
                )
                alert.addAlertAction(titleButton: "Retry") {
                    chatController.resendMessage(message: message)
                }
                alert.addAlertAction(titleButton: "Delete Message") {
                    chatController.removeUnsentMessage(message: message)
                }
                chatController.chatAlert = alert
            }
            .listRowSeparator(.hidden)
            .id(message.uuid)
            .transition(
                .move(edge: message.shouldMoveToTheLeft ? .leading : .trailing)
            )
        case is ChatRemoteMessage.Type:
            let message = message as! ChatRemoteMessage
            ChatAgentMessageCell(message: message)
                .listRowSeparator(.hidden)
                .id(message.uuid)
                .transition(.opacity)
                .zIndex(1)
        case is ChatSystemMessage.Type:
            /// TODO
            Text("hi")
        default:
            fatalError()
        }
    }
    private var maxNumberLines: Int {
        4
    }
    
    private var inputContainerView: some View {
        HStack {
            inputTextView
            sendButton
        }
    }
    
    private var sendButton: some View {
        Button("send") {
            Task {
                await chatController.sendMessage(message: toSendMessage)
                messageToSend = ""
            }
        }
        .frame(height: 34)
        .disabled(messageToSend.isEmpty)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
    
    private var inputTextView: some View {
        TextField("", text: $messageToSend, prompt: Text(verbatim: "Message"), axis: .vertical)
            .onSubmit {
                Task {
                    await chatController.sendMessage(message: toSendMessage)
                    messageToSend = ""
                }
            }
            .padding()
    }
}

struct ChatInConversationViewPreview: PreviewProvider {
    static var previews: some View {
        NavigationView  {
            ChatInConversationView<ChatController>()
                .environment(ChatController.init())
        }
    }
}

