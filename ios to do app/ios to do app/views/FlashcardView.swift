import SwiftUI

struct FlashcardView: View {
    @Environment(\.tintColor) var tintColor
    
    @ObservedObject var viewModel: TodoEditorViewModel
    @State var flashcards: [Flashcard]
    @State private var currentCard: Int = 0
    @State private var isFlipped: Bool = false
    @State private var showFlashcardEditor: Bool = false
    
    init (viewModel: TodoEditorViewModel) {
        self.viewModel = viewModel
        self.flashcards = viewModel.flashcards
    }
    
    var body: some View {
        VStack{
            VStack {
                if flashcards.isEmpty {
                    Text("No flashcards yet")
                } else {
                    Text(isFlipped ? flashcards[currentCard].back : flashcards[currentCard].front)
                }
            }
            .frame(width: 200, height: 300)
            .padding()
            .background(isFlipped ? tintColor : .white)
            .foregroundColor(isFlipped ? .white : tintColor)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(tintColor).shadow(radius: 5)
            )
            .onTapGesture {
                self.isFlipped.toggle()
            }
            
            Spacer()
    
//                .navigationBarTitle("Flashcards")
//                .toolbar {
//                    Button("New Flashcard") {
//                        self.showFlashcardEditor = true
//                    }
//                }
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
                    if self.currentCard < self.flashcards.count - 1 {
                        self.currentCard += 1
                    }
                }
            }.padding()
        }.navigationBarTitle("Flashcards")
                        .toolbar {
                            Button("New Flashcard") {
                                self.showFlashcardEditor = true
                            }
                        }

    }
}


struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView(viewModel: TodoEditorViewModel())
    }
}

