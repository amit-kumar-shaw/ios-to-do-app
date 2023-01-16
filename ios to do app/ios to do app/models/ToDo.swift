//
//  ToDo.swift
//  ios to do app
//
//  Created by Cristi Conecini on 14.01.23.
//

import Foundation
import Combine
import SwiftUI

class Todo: ObservableObject {
    
    
    
    var cancellables: [AnyCancellable] = [];
    
    @Published var selectedLanguage: Language
    @Published var name = ""
    @Published var description = ""
    @Published var startDate = Date()
    @Published var dueDate = Date()
    @Published var reminders: [Reminder] = []
    @Published var priority: Priority = .medium
    @Published var recurring: Recurring = .none
    @Published var isCompleted = false
    @Published var task = ""
    @Published var id = UUID()
    
    init(){
        self.selectedLanguage = Language(id: "en", name: "English", nativeName: "English")
        $startDate.sink { _  in
            self.dueDate = Date()
        }.store(in: &cancellables);
        
    }
    
    convenience init(selectedLanguage: Language){
        self.init()
        self.selectedLanguage = selectedLanguage
    }
}


enum Priority: String, CaseIterable, Equatable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var localizedName: LocalizedStringKey {LocalizedStringKey(rawValue)}
}

enum Recurring: String, CaseIterable, Equatable {
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

