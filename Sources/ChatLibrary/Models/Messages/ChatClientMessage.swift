//
// ChatClientMessage.swift
// 
// 
// 

import Foundation
import Observation

@Observable
public class ChatClientMessage: ChatMessage {

    var didSend: Bool
    var inTransit: Bool

    var shouldMoveToTheLeft: Bool {
        !didSend && !inTransit
    }

    init(_ content: String, didSend: Bool = false) {
        inTransit = false
        self.didSend = didSend
        super.init(content)
    }
}
