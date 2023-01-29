//
//  FlashcardListView.swift
//  ios to do app
//
//  Created by Amit Kumar Shaw on 29.01.23.
//

import SwiftUI

struct FlashcardListView: View {
    @ObservedObject var viewModel: TodoEditorViewModel
    
    init (viewModel: TodoEditorViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
            VStack {
                List {
                    Section(header: Text("Edit Flashcards")) {
                        ForEach($viewModel.flashcards, id: \.id) {
                            $flashcard in
                            HStack {
                                TextField("Front", text: $flashcard.front)
                                    .textFieldStyle(.roundedBorder)
                                TextField("Back", text: $flashcard.back)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                        }.onDelete(perform: { viewModel.deleteFlashcard(offsets: $0) })
                    }
                }
            }
            
    }
}

struct FlashcardListView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardListView(viewModel: TodoEditorViewModel())
    }
}
