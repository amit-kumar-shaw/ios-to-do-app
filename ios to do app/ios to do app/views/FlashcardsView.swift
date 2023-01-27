//
//  TodoView.swift
//  ios to do app
//
//  Created by Shivam Singh Rajput on 10.01.23.
//

import Foundation
import SwiftUI

struct FlashcardsView: View {
    @ObservedObject var flashcards: Flashcards
    @State private var showFlashcardEditor: Bool = false
    
    @State var showCard = false
    @Environment(\.presentationMode) var presentationMode
    
    init(flashcards: Flashcards, showFlashcardEditor: Bool, showCard: Bool = false) {
        self.flashcards = flashcards
        self.showFlashcardEditor = showFlashcardEditor
        self.showCard = showCard
        
    }
    
    private func addFlashcard(flashcard: Flashcard) {
        self.flashcards.cards.append(flashcard)
    }
    
    var body: some View {
            VStack {
                if !$flashcards.cards.isEmpty {
                    ForEach($flashcards.cards, id: \.id , editActions: .all){
                        $item in
                        NavigationLink(destination: FlashcardEditor(flashcards: flashcards, flashcard: item, isPresented: $showCard)){
                            HStack {
                                Text(item.front)
                            }
                        }
                    }
                }
                    NavigationLink(destination:  FlashcardView()) {
                        Label("Add Flashcard", systemImage: "plus")
                    }
                
            }
    }
}



