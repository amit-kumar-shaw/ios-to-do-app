//
//  TagView.swift
//  ios to do app
//
//  Created by Amit Kumar Shaw on 27.01.23.
//

import SwiftUI

struct TagView: View {
    @Environment(\.tintColor) var tintColor
    
    @ObservedObject var viewModel: TagViewModel
    @ObservedObject var todoViewModel: TodoListViewModel
    
    init() {
        viewModel = TagViewModel()
        todoViewModel = TodoListViewModel()
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible())], alignment: .top) {
                ForEach($viewModel.selectableTags, id: \.0) { $item in
                    Text("#\(item.1.tag!)")
                        .padding(.horizontal,8)
                        .padding(.vertical,4)
                        .background(item.2 ? tintColor : .white)
                        .foregroundColor(item.2 ? .white : tintColor)
                        .cornerRadius(16)
                        .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(tintColor)
                            )
                        .onTapGesture {
                            item.2 = !item.2
                        }
                }
            }
            .frame(height: 50)
            .padding()
            
        }
        List (selectedTags, id: \.self) { item in
            ForEach($todoViewModel.todoList, id: \.0, editActions: .all){ $todo in
                if todo.0 == item {
                    HStack{
                        Checkbox(isChecked: $todo.1.isCompleted) {
                            todoViewModel.saveTodo(entityId: todo.0, todo: todo.1)
                            todoViewModel.cloneRecurringTodoIfNecessary(entityId: todo.0, todo: todo.1)
                        }
                        NavigationLink(destination: TodoDetail(entityId: todo.0)){
                            HStack {
                                Text(todo.1.task)
                                Spacer()
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    var selectedTags: [String]{
        var list: [String] = []
        viewModel.selectableTags.forEach { item in
            if item.2 {
                item.1.todos.forEach { todo in
                    list.append(todo)
                }
            }

        }
        list.removeDuplicates()
        return list
    }
    
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView()
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

