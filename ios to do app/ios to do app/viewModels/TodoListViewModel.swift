//
//  TodoListViewModel.swift
//  ios to do app
//
//  Created by Cristi Conecini on 17.01.23.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todoList: [(String, Todo)] = []
    @Published var showAlert = false
    @Published var error: Error?
    @Published var filter: FilterType = .all
    @Published var dateFilter: Date?
    
    @Published var progress: Double = 0.0
    @Published var searchTerm = ""

    @Published var projectId: String?
    
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    
    private var cancelables: [AnyCancellable] = []
    private var querySubscription: ListenerRegistration? = nil
    
    var progress: Double {
        let totalTodos = todoList.count
        guard totalTodos != 0 else { return 0 }
        let completedTodos = todoList.filter { $1.isCompleted }.count
        return Double(completedTodos) / Double(totalTodos)
    }
    
    init() {
        setupBindings()
        loadList()
    }
    
    init(projectId: String){
        self.projectId = projectId;
    }
    
    
    private func setupBindings(){
        $filter.sink { _ in
            self.loadList()
        }.store(in: &cancelables)
        
        $dateFilter.sink { _ in
            self.loadList()
        }.store(in: &cancelables)
        
        $projectId.sink { _ in
            self.loadList()
        }.store(in: &cancelables)
        
        $todoList.sink{
            list in
            let totalTodos = self.todoList.count
            guard totalTodos != 0 else {
                self.progress =  0
                return
            }
            let completedTodos = self.todoList.filter { $0.1.isCompleted }.count
            self.progress = Double(completedTodos) / Double(totalTodos)
        }.store(in: &cancelables)
    }
    
    
    func saveTodo(entityId : String, todo : Todo) {
       
           do {
               try db.collection("todos").document(entityId).setData(from: todo)
           } catch {
               self.error = error
               self.showAlert = true
           }
           
    }
    
    
    
    
    func loadList() {
        guard let currentUserId = auth.currentUser?.uid else {
            error = AuthError()
            return
        }
        if let filter = dateFilter {
            todoList = todoList.filter { $0.1.dueDate >= filter }
        }
        
        let collectionRef = Firestore.firestore().collection("todos").whereField("userId", in: [currentUserId])
        var queryRef: Query
        
        switch filter {
            case .completed: queryRef = collectionRef.whereField("completed", isEqualTo: true)
            case .incomplete: queryRef = collectionRef.whereField("completed", isEqualTo: false)
            default: queryRef = collectionRef
        }
        
        if let projectId = projectId {
            queryRef = queryRef.whereField("projectId", isEqualTo: projectId)
        }
        if !searchTerm.isEmpty {
                queryRef = queryRef.whereField("name", isEqualTo: searchTerm).whereField("description", isEqualTo: searchTerm)
        }
        if let dateFilter = dateFilter {
                queryRef = queryRef.whereField("dueDate", isEqualTo: dateFilter)
        }
        queryRef.addSnapshotListener { querySnapshot, error in
            if error != nil{
                self.showAlert = true
                self.error = error
                print("Error getting todo list \(error!.localizedDescription)")
                return
            }
            
            do {
                let docs = try querySnapshot?.documents.map { docSnapshot in
                    (docSnapshot.documentID, try docSnapshot.data(as: Todo.self))
                }
                self.todoList = docs!
                
            } catch {
                print("Error decoding todo list \(error.localizedDescription)")
                self.error = error
                self.showAlert = true
            }
        }
    }
    
    deinit {
        querySubscription?.remove()
    }
    
}
