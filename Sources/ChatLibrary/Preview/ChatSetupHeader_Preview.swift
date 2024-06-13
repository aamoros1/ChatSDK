//
// ChatSetupHeader_Preview.swift
//
//
// 

import SwiftUI
import Foundation

private struct Block: View {
    @Bindable var controller: ChatController
    var body: some View {
        VStack {
            Button("chatting") {
                controller.chatStatus = .chatting
            }
            Button("inqeue") {
                controller.chatStatus = .inQueue
            }
            Button("requesting chat") {
                controller.chatStatus = .requestingChat
            }
        }
    }
}

#Preview {
    let controller = ChatController()
    return NavigationView {
        ChatContainerView<ChatController, Block>(chatController: controller) {
            Block(controller: controller)
        }
    }
}
