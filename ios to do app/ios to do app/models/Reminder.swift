//
//  Reminder.swift
//  ios to do app
//
//  Created by Cristi Conecini on 15.01.23.
//

import Foundation

class Reminder: Identifiable, ObservableObject {
    @Published var id = UUID()
    @Published var date: Date
    
    init(date: Date) {
        self.date = date
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
