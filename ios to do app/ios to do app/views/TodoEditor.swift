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
    @State private var showBeforeDueDatePicker = false

    
    private var languageList = Language.getAllLanguages()
   
    
    init(entityId: String?, projectId: String) {
        editMode = entityId != nil
        viewModel = TodoEditorViewModel(id: entityId,projectId: projectId)
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
                Section(header: Text("Reminders")) {
                    List {
                        
                        
                        Button(action: {
                            if (viewModel.todo.reminderBeforeDueDate < 0) {
                                viewModel.todo.reminderBeforeDueDate = -1 * viewModel.todo.reminderBeforeDueDate
                            }
                            self.showBeforeDueDatePicker = true
                        }) {
                     
                            Label("\(NotificationUtility.getRemindMeBeforeDueDateDescription(minutes: viewModel.todo.reminderBeforeDueDate)) before due date", systemImage: viewModel.todo.reminderBeforeDueDate < 0 ? "bell.slash" : "bell").strikethrough(viewModel.todo.reminderBeforeDueDate < 0).swipeActions() {
                                    Button {
                                        viewModel.muteDefaultReminder()
                                    } label: {
                                        Label("Mute", systemImage: viewModel.todo.reminderBeforeDueDate < 0 ? "bell.fill" : "bell.slash.fill")
                                    }.tint(.indigo)
                                }
                            
                        }.sheet(isPresented: $showBeforeDueDatePicker) {
                            //TimePicker(selectedTime: self.$selectedTime)TimePicker(selectedTime: $viewModel.todo.reminderBeforeDueDate)
                           
                            
                            RemindMeBeforeDueDatePicker(reminderBeforeDueDate: $viewModel.todo.reminderBeforeDueDate, isPresented: $showBeforeDueDatePicker).presentationDetents([.medium, ])
                        }
                        
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

struct RemindMeBeforeDueDatePicker: View {
    @Binding var reminderBeforeDueDate: Int
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("Remind me...")
                .multilineTextAlignment(TextAlignment.center)
              
                .padding()
        
            Picker("Select time", selection: $reminderBeforeDueDate) {
                Text("5 minutes").tag(5)
                Text("10 minutes").tag(10)
                Text("15 minutes").tag(15)
                Text("30 minutes").tag(30)
                Text("1 hour").tag(60)
                Text("2 hours").tag(120)
                Text("1 day").tag(1440)
            }.pickerStyle(.wheel)
            Text("...before due date.").multilineTextAlignment(TextAlignment.center)
                .padding()
            
            Button("Save") {
                // Save the selected time and close the sheet
                self.isPresented = false
            }
        }
    }
}
    
struct TodoEditor_Previews: PreviewProvider {
    static var previews: some View {
        TodoEditor(entityId: nil,projectId: "nil")
    }
}

private var reminderDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}
