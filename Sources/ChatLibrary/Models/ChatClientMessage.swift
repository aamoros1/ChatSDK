//
// ChatClientMessage.swift
// 
// Created by Alwin Amoros on 9/4/23.
// 

import Foundation

public class ChatClientMessage: ChatMessage {

    @Published
    var didSend: Bool
    @Published
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
