//
// ChatSystemMessageCell.swift
//
//
// 

import SwiftUI
import Foundation

struct ChatSystemMessageCell: View {
    let systemContent: ChatSystemMessage
}

extension ChatSystemMessageCell {
    
    var messageLabel: some View {
        Text(systemContent.content)
    }
    
    var body: some View {
        HStack {
            Spacer()
            messageLabel
                .padding(padding)
                .frame(minWidth: 50)
            Spacer()
        }
    }
    
    private var padding: EdgeInsets {
        .init(
            top: 10, leading: 0, bottom: 5, trailing: 0)
    }
}
