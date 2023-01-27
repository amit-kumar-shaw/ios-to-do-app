//
//  ProjectViewModel.swift
//  ios to do app
//
//  Created by dasoya on 18.01.23.
//

import SwiftUI
import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProjectViewModel : ObservableObject {

    
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    private var id: String?
    @Published var filter: FilterType = .all

    @Published var projects: [(String, Project?)] = []
    @Published var newProject: Project = .init()
    
    @Published var error: Error?
    @Published var showAlert = false
    @Published var showReminderEditor = false
    
    
    
    private var cancelables: [AnyCancellable] = []
    
    init(id: String?) {
        self.id = id
        getProject()
    }
    
    init() {
       
        self.loadList()

    }
    
    func loadList(){
        
        guard let currentUserId = auth.currentUser?.uid else{
            error = AuthError()
            return
        }
        
        let collectionRef = Firestore.firestore().collection("projects").whereField("userId", in: [currentUserId])
       
        
        collectionRef.addSnapshotListener { querySnapshot, error in
            if error != nil{
                self.showAlert = true
                self.error = error
                return
            }
            
            do{
                let docs = try querySnapshot?.documents.map({ docSnapshot -> (String, Project) in
                        let project = try docSnapshot.data(as: Project.self)
                        return (docSnapshot.documentID, project)
                });
                self.projects = docs!
            }catch {
                self.error = error
                self.showAlert = true
            }

            

            self.projects = self.projects.sorted(by: { $0.1?.timestamp ?? Date() < $1.1?.timestamp ?? Date() })
            
        }
    }
    
    private func getProject() {
        if id != nil {
            let docRef = db.collection("projects").document(id!)
            
            docRef.getDocument(as: Project.self) { result in
                
                switch result {
                    case .success(let project):
                        self.newProject = project
                    
                    case .failure(let error):
                        print("Error getting project \(error)")
                }
            }
        }
    }
    
    
    func addProject(projectInfo : ProjectInfo) {
            
      
        newProject.userId = auth.currentUser?.uid;
        newProject.projectName = projectInfo.projectName
        newProject.colorHexString = projectInfo.projectColor.toHex()
        newProject.selectedLanguage = projectInfo.selectedLanguage
        newProject.timestamp = Date()
        
            guard let documentId = id else {
                // add new project
                let newDocRef = db.collection("projects").document()
                id = newDocRef.documentID
                
                do {
                    try newDocRef.setData(from: newProject)
                    id = nil
                } catch {
                    self.error = error
                    self.showAlert = true
                }
                
                return
            }
            
            do {
                
                try db.collection("projects").document(documentId).setData(from: newProject)
            
                
            } catch {
                self.error = error
                self.showAlert = true
            }
        
    }
    
    func editProject(projectId: String, projectInfo : ProjectInfo) {

        let _project = Project(projectName: projectInfo.projectName, projectColor: projectInfo.projectColor, language: projectInfo.selectedLanguage)
        
        _project.userId = auth.currentUser?.uid;
        _project.timestamp = Date()
        
            do {
                
                try db.collection("projects").document(projectId).setData(from: _project)
            
            } catch {
                self.error = error
                self.showAlert = true
            }
        
    }
    
    
    func deleteProject(at index: Int) {
        
        let projectId = projects[index].0
        
        // code to delete the project from Firestore
        db.collection("projects").document(projectId).delete() { err in
                self.error = err
                self.showAlert = true
        }
            
        projects.remove(at: index)
    }

    
//    private let itemFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .medium
//        return formatter
//    }()
    
}


