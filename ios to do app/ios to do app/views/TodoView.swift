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
    @State var newTodo = Todo()
    // @State var name = ""
    @State var todoList = [Todo]()
    // @State var task = ""
    // @State var startDate = Date()
    // @State var dueDate = Date()
    // @State var selectedPriority = Priority.allCases.firstIndex(of: .medium) ?? 0
    // @State var selectedRecurring = Recurring.allCases.firstIndex(of: .none) ?? 0
    
    @State var showCard = false
    @Environment(\.presentationMode) var presentationMode
    
    var progress: Double {
        let totalTodos = todoList.count
        guard totalTodos != 0 else { return 0 }
        let completedTodos = todoList.filter { $0.isCompleted }.count
        return Double(completedTodos) / Double(totalTodos)
    }
    
    @State private var position = CardPosition.bottom
    @State private var background = BackgroundStyle.blur
    
    @State var selectedFilter: FilterType = .all
    
    @State var selectedWeekday = 0
    let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var filteredTodos: [Todo] {
        let selectedDay = Calendar.current.component(.weekday, from: Date())
        return todoList.filter { Calendar.current.component(.weekday, from: $0.dueDate) == selectedDay }
    }
    
    private func shouldShow(at index: Int) -> Bool {
        switch selectedFilter {
        case .all:
            return true
        case .completed:
            return todoList[index].isCompleted
        case .incomplete:
            return !todoList[index].isCompleted
        }
    }
    
    private func saveTodo() {
        todoList.append(newTodo)
        // self.newTodo = Todo()
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
                }.padding(.top, 100)
                //                Picker(selection: $selectedWeekday, label: Text("Weekday")) {
                //                               ForEach(0..<weekdays.count) {
                //                                   Text(self.weekdays[$0])
                //                               }
                //                }.pickerStyle(SegmentedPickerStyle())
                List {
                    ForEach(filteredTodos.indices, id: \.self) { index in
                        if self.shouldShow(at: index) {
                            HStack {
                                Text(self.todoList[index].task)
                                Spacer()
                                Checkbox(isChecked: self.$todoList[index].isCompleted)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        self.todoList.remove(atOffsets: indexSet)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            HStack {
                Picker(selection: $selectedFilter, label: Text("Filter"), content: {
                    ForEach(FilterType.allCases, id: \.self) { v in
                        Text(v.localizedName).tag(v)
                    }
                })
                Button(action: {
                    self.showCard = true
                    self.position = (self.position == .top) ? .bottom : .top
                }) {
                    Text("Add")
                }
                .padding()
                .fullScreenCover(isPresented: $showCard, content: {
                    TodoEditor(initialTodo: nil, onComplete: {
                        modifiedTodo in
                        self.todoList.append(modifiedTodo)
                        self.newTodo = Todo()
                        self.position = .bottom
                        self.showCard = false
                    }, onClose: {
                        self.showCard = false
                    })
                })
            }
            
//            if(showCard){
//                SlideOverCard($position, backgroundStyle: $background) {
//                    TodoEditor(initialTodo: nil){
//                        modifiedTodo in
//                        self.todoList.append(modifiedTodo)
//                        self.newTodo = Todo()
//                        self.position = .bottom
//                        self.showCard = false
//                    }
//                }
//            }
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

// struct Todo: Identifiable {
//    var id = UUID()
//    var task: String
//    var isCompleted = false
//    var startDate: Date
//    var dueDate: Date
//    var priority: Priority
//    var recurring: Recurring?
//    var reminder: Reminder?
// }

// enum Priority: String, CaseIterable {
//    case low
//    case medium
//    case high
// }
//
// enum Recurring: String, CaseIterable {
//    case none
//    case daily
//    case weekly
//    case monthly
// }
//
// struct Reminder: Identifiable {
//    var id = UUID()
//    var date: Date
// }
//
// enum FilterType: String, CaseIterable {
//    case all = "All"
//    case completed = "Completed"
//    case incomplete = "Incomplete"
// }
