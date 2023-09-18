//
// ChatSetupView.swift
// 
// Created by Alwin Amoros on 8/29/23.
//

import Foundation
import SwiftUI
import Combine

public struct ChatSetupView: View {
    @Binding
    public var textInput: String
    @EnvironmentObject
    var chatViewModel: ChatViewModel
    
    public var body: some View {
        List {
            ChatSetupHeader()
                .frame(height: 150)
                .alignmentGuide(.listRowSeparatorLeading) { dimension in
                    -dimension.width
                }
            ChatSetupChatAboutCell(inputString: $textInput)
                .alignmentGuide(.listRowSeparatorLeading) { dimension in
                    -dimension.width
                }
            Button("tap me", action: { chatViewModel.path.append(ChatNavigationStack.inQueue) } )
                
        }
        .listStyle(.plain)
    }
}

private struct ChatSetupHeader: View {
    private var securityLabelEdgeInset: EdgeInsets {
        .init(top: 15, leading: 15, bottom: 15, trailing: 15)
    }

    private var securitySubLabelEdgeInset: EdgeInsets {
        .init(top: 0, leading: 25, bottom: 15, trailing: 25)
    }
    var body: some View {
        VStack {
            securityLabel
                .padding(securityLabelEdgeInset)
            securitySubLabel
                .padding(securitySubLabelEdgeInset)
        }
    }
}

extension ChatSetupHeader {
    private var securityLabel: some View {
        Text("ChatSetupHeader.securityLabel", bundle: .module)
            .multilineTextAlignment(.center)
            .font(.system(size: 17))
            .lineLimit(2, reservesSpace: true)
            
    }

    private var securitySubLabel: some View {
        Text("ChatSetupHeader.securitySubLabel", bundle: .module)
            .multilineTextAlignment(.center)
            .font(.system(size: 13))
            .frame(height: 60)
    }
}

private struct ChatSetupChatAboutCell: View {
    @Binding var inputString: String
    private let maxCharCount = 240
    @State var shouldHidetitleQuestionLabel: Bool = false

    var body: some View {
        VStack(alignment: .center) {
            titleQuestionLabel
            textInputField
                .padding(textInputFieldEdgeInset)
            charCountLabel
        }
        .frame(height: 167)
    }
}

extension ChatSetupChatAboutCell {

    private var titleQuestionLabelEdgeInset: EdgeInsets {
        EdgeInsets(top: 32, leading: 30, bottom: 0, trailing: 15)
    }

    private var textInputFieldEdgeInset: EdgeInsets {
        EdgeInsets(top: 0, leading: 25, bottom: 53, trailing: 25)
    }

    private var localizedString: String {
        String(localized: "ChatSetupChatAboutCell.character.count", bundle: .module)
    }

    private var titleQuestionLabel: some View {
        Text("ChatSetupChatAboutCell.about.question", bundle: .module)
            .frame(height: 18)
            .padding(titleQuestionLabelEdgeInset)
            .opacity(shouldHidetitleQuestionLabel ? 0: 1)
    }

    private var charCountLabel: some View {
        HStack {
            Spacer()
            Text(String(format: localizedString, maxCharCount - inputString.count ))
                .font(.system(size: 10))
                .frame(height: 12)
                .padding(.bottom, 15)
        }
    }

    private var textInputField: some View {
        TextField("", text: $inputString, axis: .vertical)
            .onChange(of: inputString) { _ in
                shouldHidetitleQuestionLabel = !inputString.isEmpty
            }
            .font(.system(size: 15))
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(3)
    }
}

struct ChatSetupHeader_Preview: PreviewProvider {
    @State static var inputString: String = "This is a test message."
    @State static var navigation = NavigationPath()
    static var previews: some View {
        ChatSetupView(textInput: $inputString)
            .frame(width: .infinity)
    }
}
