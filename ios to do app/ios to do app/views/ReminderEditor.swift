//
//  ReminderEditor.swift
//  ios to do app
//
//  Created by Cristi Conecini on 14.01.23.
//

import SwiftUI

struct ReminderEditor: View {
    @ObservedObject var reminder: Reminder
    var onComplete: (Reminder)-> Void
    
    init(reminder: Reminder?, onComplete: @escaping (Reminder)-> Void) {
        self.reminder = reminder ?? Reminder(date: Date())
        self.onComplete = onComplete
    }
    
    func saveReminder(){
        onComplete(reminder);
    }
    
    var body: some View {
        NavigationView{
            Form{
                Group{
                    DatePicker(selection: $reminder.date, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
                        Image(systemName: "bell")
                    }
                }
            }
        }.navigationTitle("Add reminder").toolbar{
            ToolbarItem(placement: .cancellationAction){
                Button("Cancel", action: {})
                    .padding()
                    .cornerRadius(15)
            }
            ToolbarItem(placement: .confirmationAction){
                Button("Add", action: saveReminder)
                    .padding()
                    .cornerRadius(15)
            }
        }
    }
}

struct ReminderEditor_Previews: PreviewProvider {
    static var previews: some View {
        ReminderEditor(reminder: nil, onComplete: {_ in })
    }
}
