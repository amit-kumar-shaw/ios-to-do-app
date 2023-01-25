//
//  TagViewModel.swift
//  ios to do app
//
//  Created by Amit Kumar Shaw on 25.01.23.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class TagViewModel : ObservableObject {

    
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    private var id: String?
    @Published var filter: FilterType = .all

    @Published var tags: [(String, Tag?)] = []
    @Published var newTag: Tag = .init()
    
    @Published var error: Error?
    @Published var showAlert = false
//    @Published var showReminderEditor = false
    
    private var cancelables: [AnyCancellable] = []
    
    init(id: String?) {
        self.id = id
        getTag()
    }
    
    init() {
       
        self.loadList()

    }
    
    func loadList(){
        
        guard let currentUserId = auth.currentUser?.uid else{
            error = AuthError()
            return
        }
        
        let collectionRef = Firestore.firestore().collection("tags").whereField("userId", in: [currentUserId])
       
        
        collectionRef.addSnapshotListener { querySnapshot, error in
            if error != nil{
                self.showAlert = true
                self.error = error
                return
            }
            
            do{
                let docs = try querySnapshot?.documents.map({ docSnapshot -> (String, Tag) in
                        let tag = try docSnapshot.data(as: Tag.self)
                        return (docSnapshot.documentID, tag)
                });
                self.tags = docs!
            }catch {
                self.error = error
                self.showAlert = true
            }

            self.tags = self.tags.sorted(by: { $0.1?.timestamp ?? Date() < $1.1?.timestamp ?? Date() })
            
        }
    }
    
    private func getTag() {
        if id != nil {
            let docRef = db.collection("tags").document(id!)
            
            docRef.getDocument(as: Tag.self) { result in
                
                switch result {
                    case .success(let tag):
                        self.newTag = tag
                    
                    case .failure(let error):
                        print("Error getting tag \(error)")
                }
            }
        }
    }
    
    
    func addTag(tag: String, todo : String?) {
            
      
        newTag.userId = auth.currentUser?.uid;
        newTag.tag = tag
        newTag.todos.append(todo!)
        newTag.timestamp = Date()
        
            guard let documentId = id else {
                // add new tag
                let newDocRef = db.collection("tags").document()
                id = newDocRef.documentID
                
                do {
                    try newDocRef.setData(from: newTag)
                    id = nil
                } catch {
                    self.error = error
                    self.showAlert = true
                }
                
                return
            }
            
            do {
                
                try db.collection("tags").document(documentId).setData(from: newTag)
            
            } catch {
                self.error = error
                self.showAlert = true
            }
        
    }
    
    func deleteTag(at index: Int) {
        
        let tagId = tags[index].0
        
        // Delete the tag
        db.collection("tags").document(tagId).delete() { err in
                self.error = err
                self.showAlert = true
        }
            
        tags.remove(at: index)
    }

    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
}
