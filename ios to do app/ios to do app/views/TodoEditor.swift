//
//  CreateTodo.swift
//  ios to do app
//
//  Created by Cristi Conecini on 14.01.23.
//

import SwiftUI

struct TodoEditor: View {
    @ObservedObject private var todo: Todo = .init()
    private var onComplete: (Todo) -> Void
    private let editMode: Bool
    private var onClose: () -> Void
    @State private var showLanguageList = false
    @State private var showCreateReminder = false
    @State private var navigationPath = NavigationPath()
    
    private var languageList = Language.getAllLanguages()
    
    init(initialTodo: Todo?, onComplete: @escaping (Todo) -> Void, onClose: @escaping () -> Void) {
        self.onComplete = onComplete
        self.todo = initialTodo ?? Todo()
        self.editMode = initialTodo != nil
        self.onClose = onClose
    }
    
    private func saveTodo() {
        onComplete(todo)
    }
    
    private func addReminder(reminder: Reminder) {
        todo.reminders.append(reminder)
    }
    
    private func deleteReminders(offsets: IndexSet) {
        withAnimation {
            todo.reminders.remove(atOffsets: offsets)
        }
    }

    private func close() {
        onClose()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Task Details")) {
                        Group {
                            TextField("Task Name", text: $todo.task)
                            // Text("Language: \($todo.selectedLanguage.name)")
                            Picker(selection: $todo.selectedLanguage, label: Text("Language")) {
                                LanguageList()
                            }
                            Button("Select Language") {
                                self.showLanguageList.toggle()
                            }
                            DatePicker(selection: $todo.startDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
                                Text("Start Date")
                            }
                            DatePicker(selection: $todo.dueDate, in: todo.startDate..., displayedComponents: [.date, .hourAndMinute]) {
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
                    
                    Section(header: Text("Description")) {
                        TextEditor(text: $todo.description)
                    }
                    
                    Section(header: Text("Additional reminders")) {
                        NavigationStack(path: $navigationPath) {
                            List {
                                ForEach(todo.reminders) {
                                    reminder in
                                    NavigationLink(reminderDateFormatter.string(from: reminder.date), value: reminder)
//                                    NavigationLink(destinationName: "Edit reminder") {
//                                        HStack{
//                                            Image(systemName: "bell")
//                                            Text(reminder.date,  formatter: reminderDateFormatter)
//                                        }
//                                    }
                                }.onDelete(perform: deleteReminders)
                            }.navigationDestination(for: Reminder.self) {
                                reminder in
                                ReminderEditor(reminder: reminder, onComplete: { editedReminder in
                                    let index = todo.reminders.firstIndex(of: reminder)
                                    todo.reminders[index!] = editedReminder
                                })
                            }
                            Button {
                                navigationPath.append("NewReminder")
                            } label: {
                                Label("Add reminder", systemImage: "plus")
                            }
                            .navigationDestination(for: String.self) { view in
                                if view == "NewReminder" {
                                    ReminderEditor(reminder: nil, onComplete: {
                                        addReminder(reminder: $0)
                                    })
                                }
                            }
                        }
                    }
                }
            }.navigationTitle(editMode ? "Edit Todo" : "New Todo").navigationBarItems(leading:
                Button(action: close) {
                    HStack {
                        Image(systemName: "chevron.backward").font(.system(size: 20, weight: .light))
                        Text("Back")
                    }
                },
                trailing:
                Button("Add", action: saveTodo)
                    .disabled(todo.task.isEmpty)
                    .padding()
                    .cornerRadius(15)
            )
        }
    }
}

struct TodoEditor_Previews: PreviewProvider {
    static var previews: some View {
        TodoEditor(initialTodo: nil, onComplete: { todo in print(todo) }, onClose: {})
    }
}

private var reminderDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}
