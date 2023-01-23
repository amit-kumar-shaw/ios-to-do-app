//
//  TodoList.swift
//  ios to do app
//
//  Created by Cristi Conecini on 17.01.23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct TodoList: View {
    
    @ObservedObject var viewModel = TodoListViewModel()
    @State var projectId : String = ""
    
    
    init(_ dateFilter: Date? = nil,_ filter: FilterType? = nil,_ projectId : String? = nil){
        
        viewModel.dateFilter = dateFilter
        viewModel.filter = filter ?? .all
       
        if projectId != nil {
            self.projectId = projectId!
            viewModel.projectId = projectId!
            print("project :", projectId!  , self.projectId)
        }
        
    }
        
    
    var body: some View {
        
        List{
            
            ForEach($viewModel.todoList, id: \.0){
                $item in
                NavigationLink(destination: TodoDetail(entityId: item.0)){
                    HStack {
                        Text(item.1.task)
                        Spacer()
                        Button(action: {}) {
                            Checkbox(isChecked: ($item.1.isCompleted))
                        }
                        
                    }
                }
            }
        }
        .overlay(content: {if viewModel.todoList.isEmpty {
            VStack{
                Text("No todos created yet")
                NavigationLink {
                    TodoEditor(entityId: nil, projectId : self.projectId)
                } label: {
                    Label("New Todo", systemImage: "plus")
                }.buttonStyle(.bordered)
            }
        }})
            
        
    }
}

struct TodoList_Previews: PreviewProvider {
    static var previews: some View {
        TodoList()
    }
}
