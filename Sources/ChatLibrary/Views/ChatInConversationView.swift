//
// ChatInConversationView.swift
//
// 
//

import SwiftUI
import Foundation

struct ChatInConversationView<Controller>: View where Controller: ChatManagering {
    
    private struct LocalizedString {
        static var tryAgainButton: String {
            String(localized: "Try.again",
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
    var messageToSend: String = ""
    @State var showAlert: Bool = false
    
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
                }.alert(LocalizedString.alertTitle,
                        isPresented: $showAlert,
                        presenting: chatController.messageToResend)
                { message in
                    Button(LocalizedString.tryAgainButton) {
                            chatController.resendMessage(message: message)
                    }
                    Button(LocalizedString.cancelButton,
                           role: .cancel,
                           action: { showAlert = false })
                    Button(LocalizedString.removeButton,
                           role: .destructive)
                    {
                        chatController.removeUnsentMessage(message: message)
                    }
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
                showAlert = true
                chatController.tappedOnClientError(message: message)
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
            chatController.sendMessage(message: messageToSend)
            messageToSend = ""
        }
        .frame(height: 34)
        .disabled(messageToSend.isEmpty)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
    
    private var inputTextView: some View {
        TextField("", text: $messageToSend, prompt: Text(verbatim: "Message"), axis: .vertical)
            .onSubmit {
                chatController.sendMessage(message: messageToSend)
                messageToSend = ""
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

