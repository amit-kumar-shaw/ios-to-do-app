//
//  TagsInTodoView.swift
//  ios to do app
//
//  Created by Amit Kumar Shaw on 25.01.23.
//

import SwiftUI


struct TagsInTodoView: View {
    @Environment(\.tintColor) var tintColor
    
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
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .onTapGesture {
                                            viewModel.removeTodo(id: item.0, todo: self.todoId)
                                        }.foregroundColor(tintColor)
                                    
                                    Text(item.1!.tag!)
                                    
                                    Spacer()
                                    Image(systemName: "trash")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .onTapGesture {
                                            viewModel.deleteTag(id: item.0)
                                        }.foregroundColor(.red)
                                }
                            }
                        }
                    }
                                
                    Section(header: Text("Available Tags")) {
                        ForEach($viewModel.tags, id: \.0) { $item in
                            if !item.1!.todos.contains(todoId) {
                                HStack {
                                    Image(systemName: "circle")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .onTapGesture {
                                            viewModel.addTodo(id: item.0, todo: self.todoId)
                                        }.foregroundColor(tintColor)
                                    
                                    Text(item.1!.tag!)
                                    
                                    Spacer()
                                    Image(systemName: "trash")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .onTapGesture {
                                            viewModel.deleteTag(id: item.0)
                                        }.foregroundColor(.red)
                                }
                                
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
