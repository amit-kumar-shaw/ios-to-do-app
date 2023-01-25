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


   


