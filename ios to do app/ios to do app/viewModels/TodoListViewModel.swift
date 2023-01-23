//
//  TodoListViewModel.swift
//  ios to do app
//
//  Created by Cristi Conecini on 17.01.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Combine



class TodoListViewModel: ObservableObject{
    @Published var todoList: [(String, Todo)] = []
    @Published var showAlert = false
    @Published var error: Error?
    @Published var filter: FilterType = .all
    @Published var dateFilter: Date?
    @Published var projectId : String? = nil
    
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
 
    private var cancelables: [AnyCancellable] = []
    
    init() {
        //loadList()
        
        $filter.sink { filter in
            
            self.loadList()
        }.store(in: &cancelables)
    }
   

    func loadList(){
        
        guard let currentUserId = auth.currentUser?.uid else{
            error = AuthError()
            return
        }
       
//        guard let projectId = self.projectId else{
//            return
//        }
        
        let collectionRef = Firestore.firestore().collection("todos").whereField("userId", in: [currentUserId])
        var queryRef: Query
        
        
        
        switch(filter){
            case .completed : queryRef = collectionRef.whereField("completed", in: [true])
            case .incomplete : queryRef = collectionRef.whereField("completed", in: [false])
            default: queryRef = collectionRef
        }
        
        if let projectId = self.projectId{
            queryRef = queryRef.whereField("projectId", isEqualTo : projectId )
        }
        if let dateFilter = dateFilter {
                queryRef = queryRef.whereField("dueDate", isEqualTo: dateFilter)
        }
        queryRef.addSnapshotListener { querySnapshot, error in
            if error != nil{
                self.showAlert = true
                self.error = error
                return
            }
            
            do{
                let docs = try querySnapshot?.documents.map({ docSnapshot in
                    return (docSnapshot.documentID, try docSnapshot.data(as: Todo.self))
                })
                self.todoList = docs!
                
            }catch{
                self.error = error
                self.showAlert = true
            }
        }
    }
}
