//
//  ChatLogViewModel.swift
//  FirebaseChat
//
//  Created by Jayanth Ambaldhage on 10/09/23.
//

import Foundation
import Firebase
//struct ChatMessage: Identifiable{
//    var id: String {documentId}
//    var fromId, toId, text: String
//    let documentId: String
//    init(documentId: String,data : [String: Any]) {
//        self.documentId = documentId
//        self.fromId = data["fromId"] as? String ?? ""
//        self.toId = data["toId"] as? String ?? ""
//        self.text = data["text"] as? String ?? ""
//    }
//}
//class ChatLogViewModel: ObservableObject {
//    @Published var chatText = ""
//    @Published var errorMessage = ""
//    @Published var chatMessages = [ChatMessage]()
//    let chatUser: ChatUser?
//    
//    init(chatUser: ChatUser?) {
//        self.chatUser = chatUser
//        fetchMessages()
//    }
//    private func fetchMessages(){
//        
//        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
//        guard let toId = chatUser?.uid else {return}
//        
//        FirebaseManager.shared.firestore
//            .collection("messages")
//            .document(fromId)
//            .collection(toId)
//            .order(by: "timestamp")
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error {
//                    self.errorMessage = "Failed to listen to messages, \(error)"
//                    print(error)
//                    return
//                }
//                querySnapshot?.documentChanges.forEach({ change in
//                    if change.type == .added {
//                        let data = change.document.data()
//                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
//                    }
//                })
//                
//            }
//    }
//    
//    func handleSend(){
////        print(chatText)
//        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
//        guard let toId = chatUser?.uid else {return}
//      let document = FirebaseManager.shared.firestore
//            .collection("messages")
//            .document(fromId)
//            .collection(toId)
//            .document()
//        
//        let messageData = ["fromId":fromId, "toId":toId, "text":chatText, "timeStamp":Timestamp()] as [String:Any]
//        
//        document.setData(messageData) {error in
//            if let error = error {
//                self.errorMessage = "Failed to strore message into the firebase, \(error)"
//                return
//            }
//            print("Successfully saved current user sending message.")
//            self.chatText = ""
//        }
//        let recipientMessageDocument = FirebaseManager.shared.firestore
//              .collection("messages")
//              .document(toId)
//              .collection(fromId)
//              .document()
//        
//        recipientMessageDocument.setData(messageData) {error in
//            if let error = error {
//                self.errorMessage = "Failed to strore message into the firebase, \(error)"
//                return
//            }
//            print("Recipient message saved as well.")
//        }
//    }
//}



struct FirebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
}

struct ChatMessage: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, text: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
    }
}

class ChatLogViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    
    @Published var chatMessages = [ChatMessage]()
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    private func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
            }
    }
    
    func handleSend() {
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = [FirebaseConstants.fromId: fromId, FirebaseConstants.toId: toId, FirebaseConstants.text: self.chatText, "timestamp": Timestamp()] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Successfully saved current user sending message")
            self.chatText = ""
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Recipient saved message as well")
        }
    }
}
