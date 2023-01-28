//
//  FlashcardEditor.swift
//  ios to do app
//
//  Created by User on 16.01.23.
//

import SwiftUI
struct FlashcardEditor: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject private var flashcard: Flashcard
    var onComplete: (Flashcard) -> Void
    
    init(flashcard: Flashcard?, onComplete: @escaping (Flashcard) -> Void) {
        self.flashcard = flashcard ?? Flashcard()
        self.onComplete = onComplete
    }
    func saveFlashcard() {
        onComplete(flashcard)
        presentation.wrappedValue.dismiss()
    }
    var body: some View {
        Form {
            Section {
                TextField("Front", text: $flashcard.front)
                TextField("Back", text: $flashcard.back)
            }
        }
        .navigationBarTitle("New Flashcard")
        .navigationBarItems(trailing:
                                Button("Save", action:  saveFlashcard).buttonStyle(.automatic).padding()
                            )
    }
}


struct FlashcardEditor_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardEditor(flashcard: nil, onComplete: { _ in })
    }
}
