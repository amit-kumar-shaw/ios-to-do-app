//
//  CreateTodo.swift
//  ios to do app
//
//  Created by Cristi Conecini on 14.01.23.
//

import SwiftUI

struct TodoEditor: View {
    @ObservedObject private var todo: Todo = Todo()
    private var onComplete: (Todo) -> Void
    private let editMode: Bool;
    
    init(initialTodo: Todo?, onComplete: @escaping (Todo) -> Void) {
        self.onComplete = onComplete
        self.todo = initialTodo ?? Todo()
        self.editMode = initialTodo != nil
    }
    
    private func saveTodo (){
        onComplete(todo)
    }
    
    var body: some View {
        NavigationView{
            VStack {
                
                Form {
                    Section(header: Text("Task Details")) {
                        Group {
                            TextField("Task Name", text: $todo.task)
                            DatePicker(selection: $todo.startDate, in: Date()..., displayedComponents: .date) {
                                Text("Start Date")
                            }
                            DatePicker(selection: $todo.dueDate, in: todo.startDate..., displayedComponents: .date) {
                                Text("Due Date")
                            }
                        }
                    }
                    
                    Section(header: Text("Additional Details")) {
                        Group {
                            Picker(selection: $todo.priority, label: Text("Priority")) {
                                ForEach(Priority.allCases, id: \.self) { v in
                                    Text(v.localizedName).tag(v)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            Picker(selection: $todo.recurring, label: Text("Recurring")) {
                                ForEach(Recurring.allCases, id: \.self) { v in
                                    Text(v.localizedName).tag(v)
                                }
                            }
                        }
                    }
                    
                    
                    Section(header: Text("Description")){
                        TextEditor(text: $todo.description)
                    }
                    
                    
                    
                    
                }
            }.navigationTitle(editMode ? "Edit Todo" : "New Todo").toolbar{
                Button("Add", action: saveTodo)
                    .disabled(todo.task.isEmpty)
                    .padding()
                    .cornerRadius(15)
            }
        }
    }
}

struct TodoEditor_Previews: PreviewProvider {
    static var previews: some View {
        TodoEditor(initialTodo: nil, onComplete: {todo in print(todo)})
    }
}
