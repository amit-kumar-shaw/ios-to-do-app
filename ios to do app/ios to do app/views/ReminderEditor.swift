//
//  ReminderEditor.swift
//  ios to do app
//
//  Created by Cristi Conecini on 14.01.23.
//

import SwiftUI

struct ReminderEditor: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject var reminder: Reminder
    var onComplete: (Reminder) -> Void

    init(reminder: Reminder?, onComplete: @escaping (Reminder) -> Void) {
        self.reminder = reminder ?? Reminder(date: Date())
        self.onComplete = onComplete
    }

    func saveReminder() {
        onComplete(reminder)
        presentation.wrappedValue.dismiss()
    }

    var body: some View {
        VStack {
            Text("Add Reminder").font(.headline)
                DatePicker(selection: $reminder.date, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
                }.datePickerStyle(.graphical)
            Button("Save", action: saveReminder).buttonStyle(.automatic).padding()
        }
    }
}

struct ReminderEditor_Previews: PreviewProvider {
    static var previews: some View {
        ReminderEditor(reminder: nil, onComplete: { _ in })
    }
}
