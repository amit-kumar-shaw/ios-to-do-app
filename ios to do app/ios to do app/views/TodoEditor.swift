//
//  CreateTodo.swift
//  ios to do app
//
//  Created by Cristi Conecini on 14.01.23.
//

import Combine
import SwiftUI

struct TodoEditor: View {
    // @ObservedObject private var todo: Todo = .init()
    private var onComplete: (Todo) -> Void
    private let editMode: Bool
    private var onClose: () -> Void
    @State private var showLanguageList = false
    @State private var showCreateReminder = false
    @State private var navigationPath = NavigationPath()
    
    @ObservedObject private var viewModel: TodoEditorViewModel
    
    private var languageList = Language.getAllLanguages()
    
    init(entityId: String?, onComplete: @escaping (Todo) -> Void, onClose: @escaping () -> Void) {
        self.onComplete = onComplete
        editMode = entityId != nil
        self.onClose = onClose
        
        viewModel = TodoEditorViewModel(id: entityId)
    }
    
    private func saveTodo() {
        viewModel.save()
        onClose()
    }
    
    private func close() {
        onClose()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    /// Task Details
                    Section(header: Text("Task Details")) {
                        Group {
                            TextField("Task Name", text: $viewModel.todo.task)
                            // Text("Language: \($todo.selectedLanguage.name)")
                            Picker(selection: $viewModel.todo.selectedLanguage, label: Text("Language")) {
                                LanguageList()
                            }
                            Button("Select Language") {
                                self.showLanguageList.toggle()
                            }
                            DatePicker(selection: $viewModel.todo.startDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
                                Text("Start Date")
                            }
                            DatePicker(selection: $viewModel.todo.dueDate, in: viewModel.todo.startDate..., displayedComponents: [.date, .hourAndMinute]) {
                                Text("Due Date")
                            }
                        }
                    }
                    
                    /// Aditional Details
                    Section(header: Text("Additional Details")) {
                        Group {
                            Picker(selection: $viewModel.todo.priority, label: Text("Priority")) {
                                ForEach(Priority.allCases, id: \.self) { v in
                                    Text(v.localizedName).tag(v)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            Picker(selection: $viewModel.todo.recurring, label: Text("Recurring")) {
                                ForEach(Recurring.allCases, id: \.self) { v in
                                    Text(v.localizedName).tag(v)
                                }
                            }
                        }
                    }
                    
                    /// Description
                    Section(header: Text("Description")) {
                        TextEditor(text: $viewModel.todo.description)
                    }
                    
                    /// Reminders
                    Section(header: Text("Additional reminders")) {
                        List {
                            ForEach($viewModel.reminderList, id: \.id) {
                                reminder in
                                Label(reminderDateFormatter.string(from: reminder.date.wrappedValue), systemImage: "bell")
                            }.onDelete(perform: { viewModel.deleteReminders(offsets: $0) })
                            
                            NavigationLink(destination: ReminderEditor(reminder: nil, onComplete: viewModel.addReminder)) {
                                Label("Add reminder", systemImage: "plus")
                            }.toolbar {
                                ToolbarItem {
                                    EditButton()
                                }
                            }
                        }
                    }
                }.navigationTitle(editMode ? "Edit Todo" : "New Todo")
                    .navigationBarItems(leading:
                        Button(action: close) {
                            HStack {
                                Image(systemName: "chevron.backward").font(.system(size: 20, weight: .light))
                                Text("Back")
                            }
                        },
                        trailing:
                        Button("Add", action: saveTodo)
                            .disabled(viewModel.todo.task.isEmpty)
                            .padding()
                            .cornerRadius(15))
                    .alert("Error saving ToDo", isPresented: $viewModel.showAlert, actions: {
                        Button("Ok", action: { self.viewModel.showAlert = false })
                    }, message: { Text(self.viewModel.error?.localizedDescription ?? "Unknown error") })
            }
        }
    }
}
    
struct TodoEditor_Previews: PreviewProvider {
    static var previews: some View {
        TodoEditor(entityId: nil, onComplete: { todo in print(todo) }, onClose: {})
    }
}

private var reminderDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}
