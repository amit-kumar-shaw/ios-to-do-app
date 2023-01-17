//
//  Todo.swift
//  ios to do app
//
//  Created by Cristi Conecini on 14.01.23.
//

import Foundation
import Combine
import SwiftUI

class Todo: ObservableObject, Codable{
    
    @Published var selectedLanguage: Language = Language(id: "en", name: "English", nativeName: "English")
    @Published var name = ""
    @Published var description = ""
    @Published var startDate = Date()
    @Published var dueDate = Date()
    @Published var reminders: [Reminder] = []
    @Published var priority: Priority = .medium
    @Published var recurring: Recurring = .none
    @Published var isCompleted = false
    @Published var task = ""
    @Published var id: String = UUID().uuidString
    @Published var userId: String?
    
    enum CodingKeys: CodingKey {
        case selectedLanguage
        case name
        case description
        case startDate
        case dueDate
        case reminders
        case priority
        case recurring
        case isCompleted
        case task
        case id
        case userId
    }
    
    init(){
        
    }
    
    required init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        selectedLanguage = try values.decode(Language.self, forKey: .selectedLanguage)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        startDate = try values.decode(Date.self, forKey: .startDate)
        dueDate = try values.decode(Date.self, forKey: .dueDate)
        reminders = try values.decode([Reminder].self, forKey: .reminders)
        priority = try values.decode(Priority.self, forKey: .priority)
        recurring = try values.decode(Recurring.self, forKey: .recurring)
        isCompleted = try values.decode(Bool.self, forKey: .isCompleted)
        task = try values.decode(String.self, forKey: .task)
        id = try values.decode(String.self, forKey: .id)
        userId = try values.decode(String.self, forKey: .userId)
    }
    
    convenience init(selectedLanguage: Language){
        self.init()
        self.selectedLanguage = selectedLanguage
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(selectedLanguage, forKey: .selectedLanguage)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(reminders, forKey: .reminders)
        try container.encode(priority, forKey: .priority)
        try container.encode(recurring, forKey: .recurring)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(task, forKey: .task)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
    }   
}


enum Priority: String, CaseIterable, Equatable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var localizedName: LocalizedStringKey {LocalizedStringKey(rawValue)}
}

enum Recurring: String, CaseIterable, Equatable, Codable {
    case none = "None"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    
    var localizedName: LocalizedStringKey {LocalizedStringKey(rawValue)}
}



enum FilterType: String, CaseIterable, Equatable{
    
    case all = "All"
    case completed = "Completed"
    case incomplete = "Incomplete"
    
    var localizedName: LocalizedStringKey {LocalizedStringKey(rawValue)}
}

