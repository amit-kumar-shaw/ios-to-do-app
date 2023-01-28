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
    @Published var todoList: [(String, Todo)] = []
    @Published var unfilteredTodoList: [(String, Todo)] = []
    private var querySubscription: ListenerRegistration?

    init() {
        self.loadUnfilteredList()
    }
    
    func refresh() {
        self.loadUnfilteredList()
    }
    
    func loadUnfilteredList(){
        querySubscription?.remove()
        
        guard let currentUserId = Auth.auth().currentUser?.uid else{
            error = AuthError()
            return
        }
        
        let collectionRef = Firestore.firestore().collection("todos").whereField("userId", isEqualTo: currentUserId)
        
        let queryRef: Query = collectionRef
        
        self.querySubscription = queryRef.addSnapshotListener { querySnapshot, error in
            if error != nil {
                self.showAlert = true
                self.error = error
                print("[GenericTodoViewModel][loadList] Error getting todo list \(error!.localizedDescription)")
                return
            }
            
            do {
                let docs = try querySnapshot?.documents.map { docSnapshot in
                    (docSnapshot.documentID, try docSnapshot.data(as: Todo.self))
                }
                self.unfilteredTodoList = docs!
                
            } catch {
                print("[GenericTodoViewModel][loadList] Error decoding todo list \(error.localizedDescription)")
                self.error = error
                self.showAlert = true
            }
        }
        
    }
    
    func cloneRecurringTodoIfNecessary(entityId : String, todo : Todo) {
        
        // only clone when todo is marked done and is recurring
        if !todo.isCompleted || todo.recurring == .none {
            return
        }
        
        // only clone if it wasn't cloned before
        if unfilteredTodoList.contains(where: {(_, todo) in
            todo.createdByRecurringTodoId == entityId
        }) {
           return
        }
        
        // copy the todo
        
        let todoData = try! JSONEncoder().encode(todo)
        let copiedTodo = try! JSONDecoder().decode(Todo.self, from: todoData)
        
        // set the new todo not completed
        
        copiedTodo.isCompleted = false
        
        // set the next due and start date such that the due date is not reached and in the recurring schedule
        
        if (copiedTodo.recurring != .monthly) {
            for i in 1...10000 {
              
                if let recurringInterval = TimeInterval(exactly: 60 * 60 * 24 * (copiedTodo.recurring == .daily ? 1 : 7) * i) {
                    let newDueDate = copiedTodo.dueDate.addingTimeInterval(recurringInterval)
                    let newStartDate = copiedTodo.startDate.addingTimeInterval(recurringInterval)
                    if newDueDate < Date() {
                        continue
                    }
                    copiedTodo.dueDate = newDueDate
                    copiedTodo.startDate = newStartDate
                    print("YES")
                    break
                }
            }
        } else {
            let calendar = Calendar.current
            for i in 1...10000 {
            
                if let newDueDate = calendar.date(byAdding: .month, value: i, to: copiedTodo.dueDate) {
                    if newDueDate < Date() {
                        continue
                    }
                    if let newStartDate = calendar.date(byAdding: .month, value: i, to: copiedTodo.startDate) {
                        copiedTodo.dueDate = newDueDate
                        copiedTodo.startDate = newStartDate
                    }
                    break
                }
            }
        }
        
        // set createdByRecurringTodoId
        
        copiedTodo.createdByRecurringTodoId = entityId
        
        print(copiedTodo.dueDate)
        print(copiedTodo.startDate)
        
        let db = Firestore.firestore()
        let newDocRef = db.collection("todos").document()
        
        do {
            try newDocRef.setData(from: copiedTodo)
        } catch {
            self.error = error
            self.showAlert = true
        }

        // done
        self.refresh()
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
    
    deinit{
        querySubscription?.remove()
    }
}
