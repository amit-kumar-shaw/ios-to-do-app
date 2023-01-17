//
//  Reminder.swift
//  ios to do app
//
//  Created by Cristi Conecini on 15.01.23.
//

import Foundation

class Reminder: Identifiable, ObservableObject, Codable {
    @Published var id = UUID().uuidString
    @Published var date: Date = Date()
    
    enum CodingKeys: CodingKey {
        case id
        case date
    }
    
    init(){
        
    }
    
    init(date: Date) {
        self.date = date
    }
    
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decode(Date.self, forKey: .date)
        id = try values.decode(String.self, forKey: .id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
    }
}

extension Reminder: Equatable, Hashable{
    static func == (lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id);
    }
}
