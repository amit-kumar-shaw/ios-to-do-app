//
//  ProjectListViewModel.swift
//  ios to do app
//
//  Created by Cristi Conecini on 24.01.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine


class ProjectListViewModel: ObservableObject {
    
    let projectId: String
    private var cancelables: [AnyCancellable] = []
    private var querySubscription: ListenerRegistration?
    private var projectSubscription: ListenerRegistration?
    
    
    @Published var filter: FilterType = .all
    @Published var error: Error?
    @Published var showAlert = false
    @Published var progress: Double = 0.0
    @Published var todoList: [(String, Todo)] = []
    @Published var project: Project?
    private var db = Firestore.firestore()
    
    init(projectId: String){
        self.projectId = projectId
        
        setupBindings()
        loadProject()
        loadList(filter: filter)
    }
    
    func setupBindings(){
//        $filter.receive(on: DispatchQueue.main).sink { filter in
//            self.loadList(filter: filter)
//        }.store(in: &cancelables)
        
        $todoList.receive(on: DispatchQueue.main).sink{
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
    
    func loadProject(){
        projectSubscription = db.document("projects/\(projectId)").addSnapshotListener({ docSnapshot, error in
            if error != nil {
                self.showAlert = true
                self.error = error
                print("[ProjectListViewModel][loadProject] Error getting project \(error!.localizedDescription)")
                return
            }
            if((docSnapshot?.exists) != nil){
                do {
                    self.project = try docSnapshot?.data(as: Project.self)
                }catch{
                    self.error = error
                    self.showAlert = true
                    print("[ProjectListViewModel][loadProject] Error decoding project \(error.localizedDescription)")
                }
            }else{
                self.error = ProjectNotFoundError()
                self.showAlert = true
                print("[ProjectListViewModel][loadProject] Project does not exist")
            }
            
            
        })
    }
    


    func saveTodo(entityId : String, Todo : Todo){
        do {
            try db.collection("todos").document(entityId).setData(from: Todo)
        } catch {
            self.error = error
            self.showAlert = true
        }
        
    }
    

    func loadList(filter: FilterType){
       // print("Loading list with filter \(filter) ...");
        querySubscription?.remove()
        
        let collectionRef = db.collection("todos").whereField("projectId", isEqualTo: projectId)
        
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
                print("[ProjectListViewModel][loadList] Error getting todo list \(error!.localizedDescription)")
                return
            }
            
            do {
                let docs = try querySnapshot?.documents.map { docSnapshot in
                    (docSnapshot.documentID, try docSnapshot.data(as: Todo.self))
                }
                self.todoList = docs!
                
            } catch {
                print("[ProjectListViewModel][loadList] Error decoding todo list \(error.localizedDescription)")
                self.error = error
                self.showAlert = true
            }
        }
        
    }
    
    deinit{
        querySubscription?.remove()
        projectSubscription?.remove()
    }
}
