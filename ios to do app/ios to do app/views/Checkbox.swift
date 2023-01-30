//
//  Checkbox.swift
//  ios to do app
//
//  Created by Cristi Conecini on 25.01.23.
//

import Foundation
import SwiftUI

struct Checkbox: View {
    @Binding var isChecked: Bool
    @Environment(\.tintColor) var tintColor
    
    public var onToggle: () -> Void
    
    var body: some View {
        Image(systemName: "circle")
            .resizable()
            .frame(width: 25, height: 25)
            .onTapGesture {
                self.isChecked.toggle()
                self.onToggle()
            }.foregroundColor(tintColor).overlay {
                if isChecked {
                    Image(systemName: "circle.fill")
                        .frame(width: 20, height: 20)
                        .foregroundColor(tintColor)
                }
            }
    }
}

#if DEBUG
struct CheckboxStateContainer: View {
    @State var isChecked: Bool = false
    
    var body: some View{
        Checkbox(isChecked: $isChecked) {
            
        }
    }
}

struct Checkbox_Previews: PreviewProvider{
    static var previews: some View{
        CheckboxStateContainer()
    }
}
#endif
