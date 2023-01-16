//
//  Flashcards.swift
//  ios to do app
//
//  Created by User on 16.01.23.
//

import Foundation

class Flashcards: ObservableObject {
    @Published var cards: [Flashcard]
    
    init(cards: [Flashcard]) {
        self.cards = cards
    }
}


struct Flashcard: Identifiable {
    let id = UUID()
    var front: String
    var back: String
}
