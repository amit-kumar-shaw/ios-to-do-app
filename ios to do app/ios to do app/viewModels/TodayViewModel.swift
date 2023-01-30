//
//  TodayViewModel.swift
//  ios to do app
//
//  Created by Cristi Conecini on 25.01.23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import Combine


class TodayViewModel: GenericTodoViewModel {
    
    private var cancelables: [AnyCancellable] = []
    private var querySubscription: ListenerRegistration?
    
    
    @Published var filter: FilterType = .all
    @Published var lastActiveFilter: FilterType = .all
    @Published var progress: Double = 0.0
    
   
    
    override init(){
        super.init()
        setupBindings()
        loadList(filter: filter)
    }
    
    override func refresh() {
        loadList(filter: lastActiveFilter)
        super.refresh()
    }
    
    ///Initializes Publisher bindings for seamlessly updating state
    private func setupBindings(){
        $todoList.receive(on: DispatchQueue.main).sink{
            list in
            let totalTodos = self.todoList.count
            guard totalTodos != 0 else {
                self.progress =  1
                return
            }
            let completedTodos = self.todoList.filter { $0.1.isCompleted }.count
            self.progress = Double(completedTodos) / Double(totalTodos)
        }.store(in: &cancelables)
    }

    
    ///Loads the list of todos due today from firestore
    ///- Parameters:
    ///- filter: filtering condition in regard to the completion status
    func loadList(filter: FilterType){
        lastActiveFilter = filter
        querySubscription?.remove()
        
        guard let currentUserId = Auth.auth().currentUser?.uid else{
            error = AuthError()
            return
        }
        
        let collectionRef = Firestore.firestore().collection("todos").whereField("userId", isEqualTo: currentUserId)
        
        var queryRef: Query
        
        switch filter {
            case .completed: queryRef = collectionRef.whereField("isCompleted", isEqualTo: true)
            case .incomplete: queryRef = collectionRef.whereField("isCompleted", isEqualTo: false)
            default: queryRef = collectionRef
        }
    
        
        self.querySubscription = queryRef.addSnapshotListener { querySnapshot, error in
            if error != nil {
                self.showAlert = true
                self.error = error
                print("[TodayViewModel][loadList] Error getting todo list \(error!.localizedDescription)")
                return
            }
            
            do {
                let docs = try querySnapshot?.documents.map { docSnapshot in
                    (docSnapshot.documentID, try docSnapshot.data(as: Todo.self))
                }
                self.todoList = docs!
                
            } catch {
                print("[TodayViewModel][loadList] Error decoding todo list \(error.localizedDescription)")
                self.error = error
                self.showAlert = true
            }
        }
        
    }
    
    deinit{
        querySubscription?.remove()
    }
    
    
}
