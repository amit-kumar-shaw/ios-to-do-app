//
//  Project.swift
//  ios to do app
//
//  Created by dasoya on 18.01.23.
//

import Foundation
import CoreData
import SwiftUI



class Project: ObservableObject, Codable {
    
    @Published var userId: String?
    @Published var projectName: String?
    @Published var colorHexString: String?
    @Published var timestamp: Date?
    
    
    enum CodingKeys: CodingKey {
        
        case userId
        case projectName
        case colorHexString
        case timestamp
        
    }
    
    init(){
        
    }
    
    
    convenience init(projectName: String?, projectColor: Color?) {
        
           self.init()
        
        if let projectColor = projectColor, let projectName = projectName {
            self.projectName = projectName
            self.colorHexString = projectColor.toHex()
        }
    }
    
    required init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decode(String.self, forKey: .userId)
        projectName = try values.decode(String.self, forKey: .projectName)
        colorHexString = try values.decode(String.self, forKey: .colorHexString)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
      
       
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(projectName, forKey: .projectName)
        try container.encode(colorHexString, forKey: .colorHexString)
        try container.encode(timestamp, forKey: .timestamp)
    
    }
    
       
}

extension Color {
    
    func toHex() -> String {
        let components = self.cgColor?.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        
        return hexString
     }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


   


