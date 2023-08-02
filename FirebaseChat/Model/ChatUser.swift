//
//  ChatUser.swift
//  FirebaseChat
//
//  Created by Jayanth Ambaldhage on 02/08/23.
//

import Foundation
struct ChatUser {
    let uid, email, profileImageUrl : String
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
