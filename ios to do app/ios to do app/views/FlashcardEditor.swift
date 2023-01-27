//
//  FlashcardEditor.swift
//  ios to do app
//
//  Created by User on 16.01.23.
//

import SwiftUI
struct FlashcardEditor: View {
    @ObservedObject private var flashcards: Flashcards
    @State private var flashcard: Flashcard
    @Binding var isPresented: Bool
    
    init(flashcards: Flashcards, flashcard: Flashcard?, isPresented: Binding<Bool>) {
        self.flashcards = flashcards
        self._flashcard = State(initialValue: flashcard ?? Flashcard())
        self._isPresented = isPresented
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Front", text: $flashcard.front)
                TextField("Back", text: $flashcard.back)
            }
        }
        .navigationBarTitle("New Flashcard")
        .navigationBarItems(leading:
                                Button("Cancel") {
                                    self.isPresented = false
                                },
                                trailing:
                                Button("Save") {
                                    if var existingCard = flashcards.cards.first(where: {$0.id == flashcard.id}) {
                                        existingCard.front = flashcard.front
                                        existingCard.back = flashcard.back
                                    } else {
                                        self.flashcards.cards.append(flashcard)
                                    }
                                    self.isPresented = false
                                }
                            )
    }
}


struct FlashcardEditor_Previews: PreviewProvider {
    static var flashcards = Flashcards(cards:  [Flashcard()])
    static var previews: some View {
        FlashcardEditor(flashcards: flashcards, flashcard: nil, isPresented: .constant(true))
    }
}
