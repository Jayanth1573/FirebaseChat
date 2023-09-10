//
//  MainMessagesViewModel.swift
//  FirebaseChat
//
//  Created by Jayanth Ambaldhage on 17/08/23.
//

import Foundation
class  MainMessagesViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    init() {
        
        self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        fetchCurrentUser()
    }
    
     func fetchCurrentUser() {
       
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
//            self.errorMessage = "Could not find firebase uid"
            return}
        
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user:\(error)")
                return
            }
            guard let data = snapshot?.data() else { return }
            
            self.chatUser = .init(data: data)
        }
    }
    @Published var isUserCurrentlyLoggedOut = false
     func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
         try? FirebaseManager.shared.auth.signOut()
    }
}
