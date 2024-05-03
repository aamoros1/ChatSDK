//
// ChatInQueueView.swift
// 
// 
//

import SwiftUI

struct ChatInQueueView<Controller>: View where Controller: ChatController {
    
    @Environment(Controller.self) var chatController
    let queueInfo: String

    var body: some View {
        VStack {
            informativeLabel
            queueInfoDescription
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                cancelButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                collapseButton
            }
        }
    }
}

extension ChatInQueueView {
    private var informativeEdgeInset: EdgeInsets {
        .init(top: 15, leading: 35, bottom: 54, trailing: 35)
    }

    private var queueInfoDescriptionEdgeInset: EdgeInsets {
        .init(top: 0, leading: 30, bottom: 0, trailing: 30)
    }
    private var informativeLabel: some View {
        Text(queueInfo)
            .font(.system(size: 17))
            .multilineTextAlignment(.center)
            .padding(informativeEdgeInset)
    }

    private var queueInfoDescription: some View {
        Text("ChatInQueueView.queueInfoDescription", bundle: .module)
            .font(.system(size: 13))
            .multilineTextAlignment(.center)
    }
    
    private var cancelButton: some View {
        Button {
            chatController.userTappedCancelButton()
        } label: {
            Image("closeIcon", bundle: .module)
        }
        .accessibilityLabel(Text("Close", bundle: .module))
        .accessibilityHint(Text("Chat.Close.Hint", bundle: .module))
    }

    private var collapseButton: some View {
        Button {
            
        } label: {
            Image("collapse", bundle: .module)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatInQueueView<ChatController>(queueInfo: "Information")
                .environment(ChatController.init())
        }
    }
}
