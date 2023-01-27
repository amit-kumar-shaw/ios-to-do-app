//
//  SaveTodoViewModel.swift
//  ios to do app
//
//  Created by Max on 27.01.23.
//

import Foundation


import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class GenericTodoViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var error: Error?
    
    func cloneRecurringTodoIfNecessary(entityId : String, todo : Todo) {
        
        self.objectWillChange.send()
    }
    
    func saveTodo(entityId : String, todo : Todo) {
        let db = Firestore.firestore()
        do {
            try db.collection("todos").document(entityId).setData(from: todo)
        } catch {
            self.error = error
            self.showAlert = true
        }
           
    }
}
