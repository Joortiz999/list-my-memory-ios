//
//  FirebaseConstants.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 18/7/23.
//

import Foundation
import Firebase

struct FirebaseConstants {
    struct refs {
        static let databaseRoot = Database.database().reference()
        static let databaseAuthorized = databaseRoot.child("users/\(Auth.auth().currentUser?.uid ?? "")")
        static let databaseEvents = databaseAuthorized.child("events")
        static let databaseTasks = databaseAuthorized.child("tasks")
        
    }
}
