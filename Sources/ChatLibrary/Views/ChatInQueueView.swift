//
// ChatInQueueView.swift
// 
// Created by Alwin Amoros on 9/16/23.
//

import SwiftUI

struct ChatInQueueView: View {
    @EnvironmentObject
    var chatViewModel: ChatViewModel
    @EnvironmentObject
    var alertManager: AlertControllerManager
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
            var alertcontroller = AlertControllerManager.AlertController(alertTitle: "todo title", bodyMessage: "s")
            alertcontroller.addAlertAction(titleButton: "Cancel")
            alertcontroller.addAlertAction(titleButton: "Ok") {
                chatViewModel.didTapCancel()
            }
            alertManager.addAlertController(alertController: alertcontroller)
            alertManager.showAlert = true
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
        ChatInQueueView(queueInfo: "Information")
    }
}
