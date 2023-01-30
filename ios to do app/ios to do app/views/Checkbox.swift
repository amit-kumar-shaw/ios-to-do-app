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
    @Environment(\.colorScheme) var colorScheme
    public var onToggle: () -> Void
    
    func setAppIcon(tintColor: String, themePrefix: String) {
        Task {
            await RemindersWidgetUtility.setAppIcon(tintColor: tintColor, themePrefix: themePrefix)
        }
    }
    
    var body: some View {
        Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 25, height: 25)
            .onTapGesture {
                self.setAppIcon(tintColor: "#\(tintColor.toHex()?.lowercased() ?? "" )", themePrefix: colorScheme == .dark ? "Dark" : "Light")
                self.isChecked.toggle()
                self.onToggle()
            }.foregroundColor(tintColor)
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
