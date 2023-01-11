//
//  TodoView.swift
//  ios to do app
//
//  Created by Shivam Singh Rajput on 10.01.23.
//

import Foundation
import SwiftUI

import SlideOverCard

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

    @State private var position = CardPosition.bottom
    @State private var background = BackgroundStyle.blur
    
    @State var selectedFilter = 0
    
    @State var selectedWeekday = 0
    let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var filteredTodos: [Todo] {
        let selectedDay = Calendar.current.component(.weekday, from: Date())
        return todos.filter { Calendar.current.component(.weekday, from: $0.dueDate) == selectedDay }
    }
    
    private func shouldShow(at index: Int) -> Bool {
            switch FilterType.allCases[selectedFilter] {
            case .all:
                return true
            case .completed:
                return todos[index].isCompleted
            case .incomplete:
                return !todos[index].isCompleted
            }
        }

    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .bottom) {
                    Text("To Buy")
                        .font(.system(size: 50, weight: .ultraLight, design: .rounded))
                        .frame(width: UIScreen.main.bounds.width * 0.6)
                    
                    VStack {
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 50, weight: .ultraLight, design: .rounded))
                        Text("completed")
                            .font(.system(size: 18, design: .rounded))
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.3)
                }.padding(.top,100)
//                Picker(selection: $selectedWeekday, label: Text("Weekday")) {
//                               ForEach(0..<weekdays.count) {
//                                   Text(self.weekdays[$0])
//                               }
//                }.pickerStyle(SegmentedPickerStyle())
                List {
                    ForEach(filteredTodos.indices, id: \.self) { index in
                        if self.shouldShow(at: index) {
                            HStack {
                                Text(self.todos[index].task)
                                Spacer()
                                Checkbox(isChecked: self.$todos[index].isCompleted)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        self.todos.remove(atOffsets: indexSet)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            HStack{
                Picker(selection: $selectedFilter, label: Text("Filter"), content: {
                                        ForEach(0..<FilterType.allCases.count) {
                                            Text(FilterType.allCases[$0].rawValue).tag($0)
                                        }
                                    })
            Button(action: {
                            self.position = (self.position == .top) ? .bottom : .top
                        }) {
                            Text("Add")
                        }
                        .padding()
            }
                        
            SlideOverCard($position, backgroundStyle: $background) {
                VStack {
                    Form {
                        Section(header: Text("Task Details")) {
                            Group {
                                TextField("Task Name", text: $task)
                                DatePicker(selection: $startDate, in: ...Date(), displayedComponents: .date) {
                                    Text("Start Date")
                                }
                                DatePicker(selection: $dueDate, in: ...Date(), displayedComponents: .date) {
                                    Text("Due Date")
                                }
                            }
                        }

                        Section(header: Text("Additional Details")) {
                            Group {
                                Picker(selection: $selectedPriority, label: Text("Priority")) {
                                    ForEach(0 ..< Priority.allCases.count) {
                                        Text(Priority.allCases[$0].rawValue.capitalized)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                Picker(selection: $selectedRecurring, label: Text("Recurring")) {
                                ForEach(0 ..< Recurring.allCases.count) {
                                    Text(Recurring.allCases[$0].rawValue.capitalized)
                                }
                                }
                            }
                        }
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
                    }.padding()
                        .cornerRadius(15)
                    
                }
            }
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

enum FilterType: String, CaseIterable {
    case all = "All"
    case completed = "Completed"
    case incomplete = "Incomplete"
}
