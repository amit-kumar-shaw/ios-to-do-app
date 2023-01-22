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
    
    @Binding var dateFilter: Date?
    
    init(_ filter: FilterType? = nil,_ projectId : String? = nil){
        
        self._dateFilter = .constant(Date())
        viewModel.filter = filter ?? .all
        
        if projectId != nil {
            self.projectId = projectId!
        }
        
    }
        
    init(dateFilter: Binding<Date?>,_ filter: FilterType? = nil){
        self._dateFilter = dateFilter 
        viewModel.filter = filter ?? .all
    }
    
    var body: some View {
        
        List{
            
            ForEach($viewModel.todoList, id: \.0){
                $item in
                NavigationLink(destination: TodoDetail(entityId: item.0)){
                    HStack {
                        Text(item.1.task)
                        Spacer()
                        Checkbox(isChecked: $item.1.isCompleted)
                    }
                }
            }
        }.onAppear {
            viewModel.dateFilter = dateFilter
            viewModel.loadList()
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
        TodoList(dateFilter: .constant(nil))
    }
}
