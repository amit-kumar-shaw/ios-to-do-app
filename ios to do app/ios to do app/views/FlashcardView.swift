//
//  FlashcardsView.swift
//  ios to do app
//
//  Created by User on 16.01.23.
//

import SwiftUI

struct FlashcardView: View {
    @StateObject var flashcards = Flashcards(cards: [Flashcard()])
    @State private var currentCard: Int = 0
    @State private var isFlipped: Bool = false
    @State private var showFlashcardEditor: Bool = false
    
    var body: some View {
        VStack {
            if flashcards.cards.isEmpty {
                Text("No flashcards yet")
            } else {
                Text(isFlipped ? flashcards.cards[currentCard].back : flashcards.cards[currentCard].front)
                            }
        }.frame(height: 300)
            .background(RoundedRectangle(cornerRadius: 15).shadow(radius: 5))
            .padding()
        
        .navigationBarTitle("Flashcards")
        .toolbar {
            Button("New Flashcard") {
                self.showFlashcardEditor = true
            }
        }
        HStack {
            Button("Previous") {
                if self.currentCard > 0 {
                    self.currentCard -= 1
                }
            }
            Spacer()
            Button("Flip") {
                self.isFlipped.toggle()
            }
            Spacer()
            Button("Next") {
                if self.currentCard < self.flashcards.cards.count - 1 {
                    self.currentCard += 1
                }
            }
        }.padding()

    }
}


struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView()
    }
}

