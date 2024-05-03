//
// ChatSetupHeader_Preview.swift
//
//
// 

import SwiftUI
import Foundation

#Preview {
    @State var inputString: String = "This is a test message."
        return ChatSetupView<ChatController>(inputString: $inputString)
            .frame(width: .infinity)
            .environment(ChatController.init())
}
