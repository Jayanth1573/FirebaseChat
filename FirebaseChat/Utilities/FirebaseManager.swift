//
//  FirebaseManager.swift
//  FirebaseChat
//
//  Created by Jayanth Ambaldhage on 31/07/23.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager: NSObject{
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    static let shared = FirebaseManager()
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
    
}
