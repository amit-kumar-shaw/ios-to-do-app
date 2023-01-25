//
//  Weekday.swift
//  ios to do app
//
//  Created by Cristi Conecini on 25.01.23.
//

import Foundation

let WEEKDAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

struct Weekday {
    var weekday: Int
    var name: String {
        WEEKDAYS[self.weekday]
    }
    var date = Date()
    
    init(from date: Date){
        self.date = date
        self.weekday = Calendar.current.component(.weekday, from: date)
    }
}
