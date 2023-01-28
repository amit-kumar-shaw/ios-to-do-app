import SwiftUI

struct EmojiWidgetView: View {



  var body: some View {
    ZStack {
      Color(UIColor.systemIndigo)
      VStack {
        Text("Test1")
          .font(.system(size: 56))
        Text("TEST")
          .font(.headline)
          .multilineTextAlignment(.center)
          .padding(.top, 5)
          .padding([.leading, .trailing])
          .foregroundColor(.white)
      }
    }
  }
}
