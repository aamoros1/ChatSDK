//
// ChatAgentMessageCell.swift
// 
// Created by Alwin Amoros on 8/27/23.
// 

import Foundation
import SwiftUI

public struct ChatAgentMessageCell: View {
    private struct Constant {
        static let accessibilityLabel: String = .init(localized: "Chat.Agent.Message.Cell.Accessibility.Label",
                                                      bundle: .module)
    }
    let message: ChatRemoteMessage

    public init (
        message: ChatRemoteMessage)
    {
        self.message = message
    }
}

extension ChatAgentMessageCell {
    private var messageBubbleViewEdgeInset: EdgeInsets {
        EdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7)
    }

    private var agentIcon: some View {
        Image(systemName: "person.circle")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .setSquareFrame(sizeOf: 24)
            .foregroundColor(Color.red)
            .padding(.leading, 10)
    }

    private var agentNameLabel: some View {
        Text(message.agentName)
    }

    private var accessibilityLabel: Text {
        .init(verbatim: String(format: Constant.accessibilityLabel,
                               message.agentName,
                               message.timestamp, message.content))
    }

    private var messageBubbleView: some View {
        VStack(alignment: .leading) {
            agentNameLabel
            Text(message.content)
                .textSelection(.enabled)
        }
        .padding(messageBubbleViewEdgeInset)
        .frame(minWidth: 9)
        .background(
            RoundedRectangle(
                cornerRadius: 10,
                style: .circular
            )
            .fill(Color.blue)
        )
    }
    public var body: some View {
        HStack {
            agentIcon
            messageBubbleView
            Spacer(minLength: 30)
        }
        .accessibilityLabel(accessibilityLabel)
    }
}

extension View {
    func square(size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }
}
