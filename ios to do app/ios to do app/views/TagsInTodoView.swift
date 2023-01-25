//
//  TagsInTodoView.swift
//  ios to do app
//
//  Created by Amit Kumar Shaw on 25.01.23.
//

import SwiftUI


struct TagsInTodoView: View {
    
    private var todoId: String
    @ObservedObject var viewModel: TagViewModel
    
    init(todoId: String) {
        self.todoId = todoId
        viewModel = TagViewModel()
    }
    
    var body: some View {
        VStack {
            if viewModel.error != nil {
                Text(viewModel.error?.localizedDescription ?? "")
            } else {
                List {
                    Section(header: Text("Selected Tags")) {
                        ForEach($viewModel.tags, id: \.0) { $item in
                            if item.1!.todos.contains(todoId) {
                                Text(item.1!.tag!)
                            }
                        }
                    }
                                
                    Section(header: Text("Available Tags")) {
                        ForEach($viewModel.tags, id: \.0) { $item in
                            if !item.1!.todos.contains(todoId) {
                                Text(item.1!.tag!)
                            }
                        }
                        NavigationLink(destination: CreateTagView(todoId: self.todoId))
                        {
                            Label("Add Tag", systemImage: "plus")
                            
                        }
                        
                    }
                    
                }
            }
        }
    }
}

struct TagsInTodoView_Previews: PreviewProvider {
    static var previews: some View {
        TagsInTodoView(todoId: "FnrWh38iEZ32MNTm3904")
    }
}
