//
//  Tag.swift
//  ios to do app
//
//  Created by Amit Kumar Shaw on 25.01.23.
//

import Foundation
import CoreData
import SwiftUI


class Tag: ObservableObject, Codable {
    
    @Published var userId: String?
    @Published var tag: String?
    @Published var todos: [String] = []
    @Published var timestamp: Date?
    
    
    enum CodingKeys: CodingKey {
        
        case userId
        case tag
        case todoId
        case timestamp
    }
    
    init(){
        
    }
    
    
    convenience init(tag: String?) {
            self.init()
            self.tag = tag
    }
    
    required init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decode(String.self, forKey: .userId)
        tag = try values.decode(String.self, forKey: .tag)
        todos = try values.decode([String].self, forKey: .todoId)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(tag, forKey: .tag)
        try container.encode(todos, forKey: .todoId)
        try container.encode(timestamp, forKey: .timestamp)
    }
    
       
}
