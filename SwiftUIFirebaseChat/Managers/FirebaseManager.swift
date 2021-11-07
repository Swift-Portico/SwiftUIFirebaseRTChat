//
//  FirebaseManager.swift
//  SwiftUIFirebaseChat
//
//  Created by Pradeep's Macbook on 07/11/21.
//

import UIKit
import Firebase

class FirebaseManager: NSObject {
    
    static let sharedInstance = FirebaseManager()
    
    let auth: Auth
    let storage: Storage
    let fireStore: Firestore
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.fireStore = Firestore.firestore()
        super.init()
    }
}
