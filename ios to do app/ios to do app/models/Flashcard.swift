//
//  Flashcard.swift
//  ios to do app
//
//  Created by User on 15.01.23.
//

import Foundation

class Flashcards: ObservableObject {
    @Published var cards: [Flashcard]
    init(cards: [Flashcard]) {
        self.cards = cards
    }
}

struct Flashcard: Codable, Identifiable {
     let id = UUID()
     var front: String
     var back: String
 }
