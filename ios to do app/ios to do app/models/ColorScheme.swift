//
//  Settings.swift
//  ios to do app
//
//  Created by Cristi Conecini on 24.01.23.
//

import Foundation
import SwiftUI

let TINT_COLORS = ["#007AFF", "#18eb09","#e802e0","#eb7a09"]

struct TintColor {
    let name: String
    let colorHex: String
    
    init(colorHex: String){
        self.colorHex = colorHex
        switch (colorHex){
        case "#025ee8": self.name = "Blue"
        case "#18eb09": self.name = "Green"
        case "#e802e0": self.name = "Magenta"
        case "#eb7a09": self.name = "Orange"
        default: self.name = "Blue"
        }
    }
    
    var color: Color {
        Color(hex: colorHex)
    }
}


extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
