//
//  TodoView.swift
//  ios to do app
//
//  Created by Shivam Singh Rajput on 10.01.23.
//

import Foundation
import SwiftUI

import SlideOverCard

struct TodayView: View {
    @State var newTodo = Todo()
    @State var todoList = [Todo]()
    
    @StateObject var flashcards = Flashcards(cards: [Flashcard(front: "", back: "")])
    @State private var showFlashcardEditor: Bool = false
           
    
    @State var showCard = false
    @Environment(\.presentationMode) var presentationMode
    
    var progress: Double {
        let totalTodos = todoList.count
        guard totalTodos != 0 else { return 0 }
        let completedTodos = todoList.filter { $0.isCompleted }.count
        return Double(completedTodos) / Double(totalTodos)
    }
    
    @State var selectedFilter: FilterType = .all
    
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
    private func addFlashcard(flashcard: Flashcard) {
        self.flashcards.cards.append(flashcard)
    }
    
    var body: some View {
            VStack {
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text("Today")
                            .font(.system(size: 50, weight: .ultraLight, design: .rounded))
                        Text(Date().formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 18, design: .rounded))
                    }.frame(width: UIScreen.main.bounds.width * 0.7)
                    VStack(alignment: .trailing) {
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 50, weight: .ultraLight, design: .rounded))
                        Text("completed")
                            .font(.system(size: 18, design: .rounded))
                    }.frame(width: UIScreen.main.bounds.width * 0.3)
                }.padding()
               
                TodoList(Date() , selectedFilter).listStyle(.inset)
                HStack {
                                    Picker(selection: $selectedFilter, label: Text("Filter"), content: {
                                        ForEach(FilterType.allCases, id: \.self) { v in
                                            Text(v.localizedName).tag(v)
                                        }
                                    })
                                    
                                }
                                .padding()
            }
    }
}



