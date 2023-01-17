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
    
    
    init(_ filter: FilterType? = nil){
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
        }
        .overlay(content: {if viewModel.todoList.isEmpty {
            VStack{
                Text("No todos created yet")
                NavigationLink {
                    TodoEditor(entityId: nil)
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
