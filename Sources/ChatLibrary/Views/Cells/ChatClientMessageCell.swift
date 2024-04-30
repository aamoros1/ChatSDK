//
// ChatClientMessageCell.swift
// 
// Created by Alwin Amoros on 8/19/23.
//

import SwiftUI
import Foundation

public struct ChatClientMessageCell: View {
    private var message: ChatClientMessage
    private let retryAction: () -> ()

    public init (
        message: ChatClientMessage,
        retryAction: @escaping () -> ())
    {
        self.message = message
        self.retryAction = retryAction
    }
}

extension ChatClientMessageCell {
    private var messageBubbleViewEdgeInset: EdgeInsets {
        EdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7)
    }

    private var retryButtonEdgeInset: EdgeInsets {
        EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 6)
    }

    private var retryButton: some View {
        Button(action: retryAction) {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.red)
        }
        .setSquareFrame(sizeOf: 20)
        .padding(retryButtonEdgeInset)
    }

    private var messageBubbleView: some View {
        Text(message.content)
            .frame(minWidth: 9)
            .padding(messageBubbleViewEdgeInset)
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
            Spacer(minLength: 55)
            messageBubbleView
                .padding(.trailing, 2)
            if !message.didSend {
                retryButton
            }
        }
    }
}

struct PreviewChatClientMessageCell: PreviewProvider {
    static var previews: some View {
        Group {
            ChatClientMessageCell(
                message: .init(
                    "sent message",
                    didSend: true),
                retryAction: {})
            .previewLayout(PreviewLayout.sizeThatFits)
            .preferredColorScheme(.light)
            .previewDisplayName("lightmode")
            ChatClientMessageCell(
                message: .init(
                    "failed message",
                    didSend: false),
                retryAction: {})
            .previewLayout(PreviewLayout.sizeThatFits)
            .preferredColorScheme(.dark)
            .previewDisplayName("darkmode")
        }
    }
}
