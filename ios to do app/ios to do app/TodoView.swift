//
//  TodoView.swift
//  ios to do app
//
//  Created by Shivam Singh Rajput on 10.01.23.
//

import Foundation
import SwiftUI

struct TodoList: View {
    @State var name = ""
    @State var todos = [Todo]()
    @State var task = ""
    @State var startDate = Date()
    @State var dueDate = Date()
    @State var selectedPriority = Priority.allCases.firstIndex(of: .medium) ?? 0
    @State var selectedRecurring = Recurring.allCases.firstIndex(of: .none) ?? 0
    @State var reminder: Reminder?
    @State var showCard = true
    @Environment(\.presentationMode) var presentationMode
    var progress: Double {
        let totalTodos = todos.count
            guard totalTodos != 0 else { return 0 }
            let completedTodos = todos.filter { $0.isCompleted }.count
            return Double(completedTodos) / Double(totalTodos)
        }
    var body: some View {
           VStack {
               Text("To-Do List")
                   .font(.largeTitle)
               
               Text("Progress: \(Int(progress * 100))%")
               
               List {
                   ForEach(todos.indices, id: \.self) { index in
                       HStack {
                           Text(self.todos[index].task)
                           Spacer()
                           Checkbox(isChecked: self.$todos[index].isCompleted)
                       }
                   }
                   .onDelete { indexSet in
                       self.todos.remove(atOffsets: indexSet)
                   }
               }
               ZStack{
                   if showCard {
                       Form{
                           
                           Section(header: Text("Task Details")){
                               Group{
                                   TextField("Task Name", text: $task)
                                   DatePicker(selection: $startDate, in: ...Date(), displayedComponents: .date) {
                                       Text("Start Date")
                                   }
                                   DatePicker(selection: $dueDate, in: ...Date(), displayedComponents: .date) {
                                       Text("Due Date")
                                   }
                               }
                           }
                           
                           Section(header: Text("Additional Details")){
                               Group{
                                   Picker(selection: $selectedPriority, label: Text("Priority")) {
                                       ForEach(0 ..< Priority.allCases.count) {
                                           Text(Priority.allCases[$0].rawValue.capitalized)
                                       }
                                   }
                                   .pickerStyle(SegmentedPickerStyle())
                                   //                           if self.selectedRecurring != 0 {
                                   //                               DatePicker(selection: $reminder?.date, in: ...Date(), displayedComponents: .date) {
                                   //                                   Text("Reminder")
                                   //                               }
                                   //                           }
                                   Picker(selection: $selectedRecurring, label: Text("Recurring")) {
                                       ForEach(0 ..< Recurring.allCases.count) {
                                           Text(Recurring.allCases[$0].rawValue.capitalized)
                                       }
                                   }
                               }
                           }
                           HStack{
                               Spacer()
                               Button(action: {
                                   self.todos.append(Todo(task: self.task, startDate: self.startDate, dueDate: self.dueDate, priority: Priority.allCases[self.selectedPriority], recurring: self.selectedRecurring != 0 ? Recurring.allCases[self.selectedRecurring] : nil, reminder: self.reminder))
                                   self.task = ""
                                   self.startDate = Date()
                                   self.dueDate = Date()
                                   self.selectedPriority = 0
                                   self.selectedRecurring = 0
                                   self.reminder = nil
                               }, label: {
                                   Text("Add")
                               })
                               .disabled(task.isEmpty)
                               Spacer()
                           }
                       }}
               }.cornerRadius(15).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
                   .shadow(radius: 8)
                   .offset(x:0, y:100)
               }
               .onTapGesture {
                   self.showCard = false
               }
           }
       }
    

struct Checkbox: View {
    @Binding var isChecked: Bool

    var body: some View {
        Button(action: {
            self.isChecked.toggle()
        }, label: {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 25, height: 25)
        })
    }
}
struct Todo: Identifiable {
    var id = UUID()
    var task: String
    var isCompleted = false
    var startDate: Date
    var dueDate: Date
    var priority: Priority
    var recurring: Recurring?
    var reminder: Reminder?
}

enum Priority: String, CaseIterable {
    case low
    case medium
    case high
}

enum Recurring: String, CaseIterable {
    case none
    case daily
    case weekly
    case monthly
}

struct Reminder: Identifiable {
    var id = UUID()
    var date: Date
}
