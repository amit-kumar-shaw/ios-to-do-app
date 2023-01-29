import SwiftUI

struct FlashcardView: View {
    @Environment(\.tintColor) var tintColor
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: TodoEditorViewModel
    @State private var currentCard: Int = 0
    @State private var isFlipped: Bool = false
    @State var flashcardRotation = 0.0
    @State var contentRotation = 0.0
    @State private var showFlashcardEditor: Bool = false
    
    init (viewModel: TodoEditorViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            VStack {
                if viewModel.flashcards.isEmpty {
                    Text("No flashcards yet")
                } else {
                    Text(isFlipped ? viewModel.flashcards[currentCard].back : viewModel.flashcards[currentCard].front)
                }
            }
            .bold()
            .rotation3DEffect(.degrees(contentRotation), axis: (x: 0, y: 1, z: 0))
            .frame(width: 200, height: 300)
            .padding()
            .background(colorScheme == .dark ? (isFlipped ? tintColor : .black) : (isFlipped ? tintColor : .white))
            .foregroundColor(isFlipped ? .white : tintColor)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(tintColor).shadow(radius: 5)
            )
            .onTapGesture {
                flipFlashcard()
            }
            .rotation3DEffect(.degrees(flashcardRotation), axis: (x: 0, y: 1, z: 0))
            
            Spacer()
            
            HStack {
                Button("Previous") {
                    if self.currentCard > 0 {
                        isFlipped = false
                        self.currentCard -= 1
                    }
                }.disabled(self.currentCard == 0)
                Spacer()
                Button("Flip") {
                    flipFlashcard()
                }
                Spacer()
                Button("Next") {
                    if self.currentCard < self.viewModel.flashcards.count - 1 {
                        isFlipped = false
                        self.currentCard += 1
                    }
                }.disabled(self.currentCard == self.viewModel.flashcards.count - 1)
            }.padding()
        }.navigationBarTitle("Flashcards")
                        .toolbar {
                            NavigationLink(destination: FlashcardListView(viewModel: viewModel)){
                                Text("Edit")
                            }
                            Button(action: viewModel.toggleFlashcardEditor) {
                                Text("Add")
                            }.sheet(isPresented: $viewModel.showFlashcardEditor) {
                                FlashcardEditor(viewModel: viewModel)
                            }
                            
                        }

    }
    
    func flipFlashcard() {
            let animationTime = 0.5
            withAnimation(Animation.linear(duration: animationTime)) {
                flashcardRotation += 180
            }
            
            withAnimation(Animation.linear(duration: 0.001).delay(animationTime / 2)) {
                contentRotation += 180
                isFlipped.toggle()
            }
        }
}


struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView(viewModel: TodoEditorViewModel())
    }
}

