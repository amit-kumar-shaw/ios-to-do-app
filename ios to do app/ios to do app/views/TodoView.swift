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
    @ObservedObject var todoListViewModel = TodoListViewModel()
    @State var project : (String, Project)
    
    
    @StateObject var flashcards = Flashcards(cards: [Flashcard()])
    @State private var showFlashcardEditor: Bool = false
           
    
    @State var showCard = false
    @Environment(\.presentationMode) var presentationMode
    
    @State var selectedFilter: FilterType = .all
    
    
    
    
    
    
//    private func shouldShow(at index: Int) -> Bool {
//        switch selectedFilter {
//        case .all:
//            return true
//        case .completed:
//            return todoList[index].isCompleted
//        case .incomplete:
//            return !todoList[index].isCompleted
//        }
//    }
//
//    private func saveTodo() {
//        todoList.append(newTodo)
//        // self.newTodo = Todo()
//    }
    private func addFlashcard(flashcard: Flashcard) {
        self.flashcards.cards.append(flashcard)
    }
    
    var body: some View {
            VStack {
                HStack(alignment: .bottom) {
                    if let name = self.project.1.projectName {
                        Text(name)
                            .font(.system(size: 50, weight: .ultraLight, design: .rounded))
                            .frame(width: UIScreen.main.bounds.width * 0.6)
                    }
                    VStack {
                        Text("\(Int(todoListViewModel.progress * 100))%")
                            .font(.system(size: 50, weight: .ultraLight, design: .rounded))
                        Text("completed")
                            .font(.system(size: 18, design: .rounded))
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.3)
                }.padding()
                
                TodoList(nil,selectedFilter, self.project.0).listStyle(.inset).toolbar(){
                    ToolbarItem(placement: .automatic) {
                        EditButton()
                    }
                }
                HStack {
                    Picker(selection: $selectedFilter, label: Text("Filter"), content: {
                        ForEach(FilterType.allCases, id: \.self) { v in
                            Text(v.localizedName).tag(v)
                        }
                    })
                    NavigationLink {
                        CreateTodoView(projectId :project.0)
                    } label: {
                        Text("Add").padding()
                    }
                }
                .padding()
            }
    }
}



struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView(project: ("",Project(projectName: "Preview", projectColor: Color.brown)))
    }
}
