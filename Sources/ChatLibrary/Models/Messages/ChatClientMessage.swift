//
// ChatClientMessage.swift
// 
// 
// 

import Foundation
import Observation

@Observable
public class ChatClientMessage: ChatMessage {

    public var didSend: Bool
    public var inTransit: Bool

    var shouldMoveToTheLeft: Bool {
        !didSend && !inTransit
    }

    public init(_ content: String, didSend: Bool = false) {
        inTransit = false
        self.didSend = didSend
        super.init(content)
    }
}
