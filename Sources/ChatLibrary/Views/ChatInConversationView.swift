//
// ChatInConversationView.swift
// 
// Created by Alwin Amoros on 9/4/23.
// 

import Foundation
import SwiftUI

public struct ChatInConversationView: View {

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
    
    @EnvironmentObject
    var viewModel: ChatViewModel
    @State
    var enableSendButton: Bool = false
    
    public var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(viewModel.messages, id: \.uuid) { message in
                        cellForRow(message: message)
                    }
                }
                .onChange(of: viewModel.messages) { message in
                    proxy.scrollTo(message.last?.uuid)
                }.alert(LocalizedString.alertTitle,
                        isPresented: $viewModel.showAlert,
                        presenting: viewModel.messageToResend)
                { message in
                    Button(LocalizedString.tryAgainButton) {
                        Task {
                            await viewModel.resendMessage(message)
                        }
                    }
                    Button(LocalizedString.cancelButton,
                           role: .cancel,
                           action: { viewModel.showAlert = false })
                    Button(LocalizedString.removeButton,
                           role: .destructive)
                    {
                        viewModel.removeUnsentMessage(message)
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
                    viewModel.userTappedCancelButton()
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
                viewModel.tappedOnClientError(message)
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
            viewModel.sendMessage()
        }
        .frame(height: 34)
        .disabled(enableSendButton)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }

    private var inputTextView: some View {
        TextField("", text: $viewModel.messageToSend, prompt: Text(verbatim: "Message"), axis: .vertical)
            .onReceive(viewModel.$messageToSend) { inputText in
                enableSendButton = inputText.isEmpty
            }
            .onSubmit {
                viewModel.sendMessage()
            }
            .padding()
    }
}

struct ChatInConversationViewPreview: PreviewProvider {
    static var previews: some View {
        let viewModel = ChatViewModel()
        viewModel.populateWithMockMessage()
        return VStack {
            ChatInConversationView()
                .environmentObject(viewModel)
        }
    }
}

extension ChatViewModel {
    func populateWithMockMessage() {
        Task(priority: .background) {
            while true {
                let randomSeconds = UInt64.random(in: 1..<10)
                try await Task.sleep(nanoseconds: randomSeconds * 1000000000)
                await addNewMessage(
                    ChatClientMessage("content1"))
                try await Task.sleep(nanoseconds: 2000000000)
                
                await addNewMessage(ChatRemoteMessage("hello", identifier: "1"))
                
                let randomSeconds1 = UInt64.random(in: 3..<16)
                try await Task.sleep(nanoseconds: randomSeconds1 * 1000000000)
                await addNewMessage(
                    ChatClientMessage(
                        "content2",
                        didSend: randomSeconds1 % 5 == 0 ))
            }
        }
    }
}
