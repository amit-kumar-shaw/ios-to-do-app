//
//  TodoView.swift
//  ios to do app
//
//  Created by Shivam Singh Rajput on 10.01.23.
//

import Foundation
import SwiftUI

import SlideOverCard

struct TodoView: View {
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
                    Text("To Buy")
                        .font(.system(size: 50, weight: .ultraLight, design: .rounded))
                        .frame(width: UIScreen.main.bounds.width * 0.7)
        
                    VStack {
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 50, weight: .ultraLight, design: .rounded))
                        Text("completed")
                            .font(.system(size: 18, design: .rounded))
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.3)
                }.padding(.top, 100)
                
                TodoList(dateFilter: .constant(nil),selectedFilter).listStyle(.inset)
                
//                List {
//                    ForEach(filteredTodos.indices, id: \.self) { index in
//                        if self.shouldShow(at: index) {
//                            HStack {
//                                Text(self.todoList[index].task)
//                                Spacer()
//                                Checkbox(isChecked: self.$todoList[index].isCompleted)
//                            }
//                        }
//                    }
//                    .onDelete { indexSet in
//                        self.todoList.remove(atOffsets: indexSet)
//                    }
//                }
//                List {
//                    ForEach(flashcards.cards) { flashcard in
//                        NavigationLink(destination: FlashcardView(flashcards: flashcards)) {
//                            Text(flashcard.front)
//                        }
//                    }
//                    Button("New Flashcard") {
//                        self.showFlashcardEditor = true
//                    }
//                }.padding(.zero)
                HStack {
                    Picker(selection: $selectedFilter, label: Text("Filter"), content: {
                        ForEach(FilterType.allCases, id: \.self) { v in
                            Text(v.localizedName).tag(v)
                        }
                    })
                    NavigationLink {
                        TodoEditor(entityId: nil)
                    } label: {
                        Text("Add").padding()
                    }
                }
                .padding()
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
