//
//  FlashcardEditor.swift
//  ios to do app
//
//  Created by User on 16.01.23.
//

import SwiftUI
struct FlashcardEditor: View {
    @ObservedObject private var flashcard: Flashcard
    @ObservedObject var viewModel: TodoEditorViewModel
//    var onComplete: (Flashcard) -> Void
    
//    init(flashcard: Flashcard?, onComplete: @escaping (Flashcard) -> Void) {
//        self.flashcard = flashcard ?? Flashcard()
//        self.onComplete = onComplete
//    }
    init (viewModel: TodoEditorViewModel) {
        self.flashcard = Flashcard()
        self.viewModel = viewModel
    }
    func saveFlashcard() {
//        onComplete(flashcard)
        viewModel.addFlashcard(flashcard: flashcard)
        viewModel.save()
        viewModel.toggleFlashcardEditor()
    }
    var body: some View {
        Form {
            Section {
                TextField("Front", text: $flashcard.front)
                TextField("Back", text: $flashcard.back)
            }
            Button("Save", action: saveFlashcard)
                .disabled(flashcard.front.isEmpty || flashcard.back.isEmpty)
            
        }
        
    }
}


struct FlashcardEditor_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardEditor(viewModel: TodoEditorViewModel())
    }
}
