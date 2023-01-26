//
//  SearchView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 25.01.23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SearchView: View {
    
//    let searchText = "index"
    @Binding var searchText: String
    @ObservedObject var projectViewModel = ProjectViewModel()
    @ObservedObject var todoViewModel = ProjectViewModel()
    
    var body: some View {
//        Text("Search for todos and projects!").onAppear{
//            Firestore.firestore().collection("projects").whereField("projectName", arrayContains: searchText).getDocuments { qs, err in
//                    if err == nil {
//                        let docs = qs?.documents.map({ docSnap in
//                            return docSnap.data()
//                        })
//
//                        print("\(searchText) results: \(docs)")
//                    }
//                }
//        }
        
        VStack(alignment: .leading) {
            
                Section(header: Text("Projects")) {
                    ForEach($projectViewModel.projects, id: \.0) { $item in
                        if let _ = item.1!.projectName!.range(of: searchText, options: .caseInsensitive) {
//                            NavigationLink(destination: ProjectListView(projectId: item.0)) {
                                ProjectListRow(project: item.1!)
                                .onTapGesture {
                                    ProjectListView(projectId: item.0)
                                }
//                            }
                            
                        }
                    }
                }
            
//            Section(header: Text("Todos")) {
//                ForEach($todoViewModel.todoList, id: \.0) { $item in
//                        if let range = item.1!.task!.range(of: searchText, options: .caseInsensitive) {
//                            NavigationLink(destination: ProjectListView(projectId: item.0)) {
//                            ProjectListRow(project: item.1!)
//                        }
//
//                    }
//                }
//            }
                
            
        }.padding()
        
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView(searchText: "")
//    }
//}
