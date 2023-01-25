//
//  TodoEditorViewModel.swift
//  ios to do app
//
//  Created by Cristi Conecini on 17.01.23.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

class TodoEditorViewModel: ObservableObject {
    
    @Environment(\.presentationMode) var presentation
    
    private var cancellables: [AnyCancellable] = []
    
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    private var id: String?
    
    @Published var todo: Todo = .init()
    @Published var reminderList: [Reminder] = []
    
    @Published var error: Error?
    @Published var showAlert = false
    @Published var showReminderEditor = false
    
    
    init(id: String?) {
        self.id = id
        getTodo()
        setupRestrictions()
    }
    
    init(projectId: String = ""){
        todo.projectId = projectId
    }
    
    
    private func setupRestrictions() {
        todo.$startDate.sink {
            _ in
            self.todo.dueDate = Date()
        }.store(in: &cancellables)
    }
        
    private func getTodo() {
        guard let id = self.id else {
            return
        }
        
        let docRef = db.collection("todos").document(id)
        
        docRef.getDocument(as: Todo.self) { result in
            
            switch result {
                case .success(let todo):
                    self.todo = todo
                    self.reminderList = todo.reminders
                case .failure(let error):
                    print("Error getting todo \(error)")
            }
        }
    }
    
    func muteDefaultReminder() {
        todo.reminderBeforeDueDate.negate()
        self.objectWillChange.send()
    }
    
    func toggleReminderEditor(){
        showReminderEditor.toggle()
    }
    
    func addReminder(reminder: Reminder) {
        reminderList.append(reminder)
    }
    
    func deleteReminders(offsets: IndexSet) {
        print("deleting reminders: \(offsets)")
        reminderList.remove(atOffsets: offsets)
    }
    
    func save() {
        todo.reminders = reminderList
        todo.userId = auth.currentUser?.uid;
        guard let documentId = id else {
            let newDocRef = db.collection("todos").document()
            id = newDocRef.documentID
            
            do {
                try newDocRef.setData(from: todo)
            } catch {
                self.error = error
                self.showAlert = true
            }
            
            return
        }
        
        guard todo.projectId != nil else {
            
            print("project id nill")
            
            return
        }
        
        do {
            try db.collection("todos").document(documentId).setData(from: todo)
        } catch {
            self.error = error
            self.showAlert = true
        }
    }
    
    deinit {}
}
