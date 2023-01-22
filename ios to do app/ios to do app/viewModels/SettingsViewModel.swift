//
//  SettingsViewModel.swift
//  ios to do app
//
//  Created by Cristi Conecini on 16.01.23.
//

import Foundation
import FirebaseAuth
import SwiftUI


enum ColorSchemeOption: String, CaseIterable, Decodable {
    case defaultColor = "Default"
    case blue = "Blue"
    case green = "Green"
    case pink = "Pink"
}

struct ColorScheme {
    let primary: Color
    let secondary: Color
    let accent: Color
    let background: Color
    let text: Color
    let error: Color
}

class Settings: ObservableObject, Decodable, Encodable{
    @Published var selectedColorScheme: ColorSchemeOption = .defaultColor
    @Published var fontSize: Double = 18

   enum CodingKeys: String, CodingKey {
       case selectedColorScheme
       case fontSize
   }
    
    
    
    init(){
        
    }
    
    
    required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            selectedColorScheme = try values.decode(ColorSchemeOption.self, forKey: .selectedColorScheme)
            fontSize = try values.decode(Double.self, forKey: .fontSize)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(selectedColorScheme.rawValue, forKey: .selectedColorScheme)
        try container.encode(fontSize, forKey: .fontSize)
    }
}

class SettingsViewModel: ObservableObject {
    @Published var settings = Settings()
    @Published var error: Error? = nil

    private var firAuth = Auth.auth()
    
    init() {
        load()
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: "Settings") {
            if let decoded = try? JSONDecoder().decode(Settings.self, from: data) {
                self.settings = decoded
                return
            }
        }
        self.settings = Settings()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: "Settings")
        }
    }

    func signOut(){
        do {
            try firAuth.signOut()
        } catch {
            print("Error signing out", error)
            self.error = error
        }
    }
}
