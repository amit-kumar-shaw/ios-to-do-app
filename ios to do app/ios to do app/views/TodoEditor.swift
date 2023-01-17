//
//  CreateTodo.swift
//  ios to do app
//
//  Created by Cristi Conecini on 14.01.23.
//

import Combine
import SwiftUI

struct TodoEditor: View {
    @Environment(\.presentationMode) var presentation
    
    private let editMode: Bool
    
    @ObservedObject private var viewModel: TodoEditorViewModel
    
    private var languageList = Language.getAllLanguages()
    
    init(entityId: String?) {
        editMode = entityId != nil
        
        viewModel = TodoEditorViewModel(id: entityId)
    }
    
    private func saveTodo() {
        viewModel.save()
        close()
    }
    
    private func close() {
        presentation.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            Form {
                /// Task Details
                Section(header: Text("Task Details")) {
                    Group {
                        TextField("Task Name", text: $viewModel.todo.task)
                        Picker(selection: $viewModel.todo.selectedLanguage, label: Text("Language")) {
                            LanguageList()
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
                            
                        Button(action: viewModel.toggleReminderEditor) {
                            Label("Add reminder", systemImage: "plus")
                        }.sheet(isPresented: $viewModel.showReminderEditor){
                            ReminderEditor(reminder: nil, onComplete: viewModel.addReminder)
                        }
                    }
                }
            }
        }
        .navigationTitle(editMode ? "Edit Todo" : "New Todo").navigationBarTitleDisplayMode(.large)
        .toolbar(content: {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add", action: saveTodo)
                    .disabled(viewModel.todo.task.isEmpty)
                    .padding()
                    .cornerRadius(15)
                    .alert("Error saving ToDo", isPresented: $viewModel.showAlert, actions: {
                        Button("Ok", action: { self.viewModel.showAlert = false })
                    }, message: { Text(self.viewModel.error?.localizedDescription ?? "Unknown error") })
            }
        })
    }
}
    
struct TodoEditor_Previews: PreviewProvider {
    static var previews: some View {
        TodoEditor(entityId: nil)
    }
}

private var reminderDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}
