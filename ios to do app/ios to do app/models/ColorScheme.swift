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
