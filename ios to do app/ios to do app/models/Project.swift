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
    @Published var selectedLanguage: Language = Language(id: "en", name: "English", nativeName: "English")
    @Published var timestamp: Date?
    
    
    enum CodingKeys: CodingKey {
        
        case userId
        case projectName
        case colorHexString
        case timestamp
        case selectedLanguage
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
    
    convenience init(projectName: String?, projectColor: Color?,language : Language ) {
        
           self.init()
        
        if let projectColor = projectColor, let projectName = projectName {
            self.projectName = projectName
            self.colorHexString = projectColor.toHex()
            self.selectedLanguage = language
        }
    }
    
    required init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let isoFormatter = ISO8601DateFormatter()
        
        userId = try values.decode(String.self, forKey: .userId)
        projectName = try values.decode(String.self, forKey: .projectName)
        colorHexString = try values.decode(String.self, forKey: .colorHexString)
        
        let timestampIso = try values.decode(String.self, forKey: .timestamp)
        guard let timestamp = isoFormatter.date(from: timestampIso) else {
            throw DateError()
        }
        self.timestamp = timestamp
      
        selectedLanguage = try values.decode(Language.self, forKey: .selectedLanguage)
       
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(projectName, forKey: .projectName)
        try container.encode(colorHexString, forKey: .colorHexString)
        try container.encode(timestamp?.ISO8601Format(), forKey: .timestamp)
        try container.encode(selectedLanguage, forKey: .selectedLanguage)
    
    }
    
       
}


   


