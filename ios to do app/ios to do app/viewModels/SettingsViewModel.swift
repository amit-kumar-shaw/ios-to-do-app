//
//  SettingsViewModel.swift
//  ios to do app
//
//  Created by Cristi Conecini on 16.01.23.
//

import Foundation
import FirebaseAuth

enum AccentColor: String, Decodable {
    case blue
    case red
    case yellow
}

class Settings: ObservableObject, Decodable, Encodable{
    @Published var accentColor: AccentColor = .blue
    
    enum CodingKeys: String, CodingKey {
        case accentColor
    }
    
    
    
    init(){
        
    }
    
    
    required init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accentColor = try values.decode(AccentColor.self, forKey: .accentColor)
    }
    
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(accentColor.rawValue, forKey: .accentColor)
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
