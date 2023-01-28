//
//  Flashcard.swift
//  ios to do app
//
//  Created by User on 27.01.23.
//

import Foundation

class Flashcard: ObservableObject, Identifiable, Codable{
    @Published var id = UUID().uuidString
    @Published var front: String = ""
    @Published var back: String = ""
    
    enum CodingKeys: CodingKey{
        case id
        case front
        case back
    }
    
    init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        front = try values.decode(String.self, forKey: .front)
        back = try values.decode(String.self, forKey: .back)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(front, forKey: .front)
        try container.encode(back, forKey: .back)
        
    }
}
