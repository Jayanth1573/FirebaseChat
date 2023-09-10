//
//  ChatLogViewModel.swift
//  FirebaseChat
//
//  Created by Jayanth Ambaldhage on 10/09/23.
//

import Foundation
import Firebase
class ChatLogViewModel: ObservableObject {
    @Published var chatMessage = ""
    @Published var errorMessage = ""
    let chatUser: ChatUser?
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
    }
    func handleSend(){
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
      let document = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = ["fromId":fromId, "toId":toId, "text":chatMessage, "timeStamp":Timestamp()] as [String:Any]
        
        document.setData(messageData) {error in
            if let error = error {
                self.errorMessage = "Failed to strore message into the firebase, \(error)"
                return
            }
            self.chatMessage = ""
        }
        let recipientMessageDocument = FirebaseManager.shared.firestore
              .collection("messages")
              .document(toId)
              .collection(fromId)
              .document()
        
        recipientMessageDocument.setData(messageData) {error in
            if let error = error {
                self.errorMessage = "Failed to strore message into the firebase, \(error)"
                return
            }
        }
    }
}
