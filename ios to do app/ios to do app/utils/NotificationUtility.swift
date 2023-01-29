//
//  NotificationScheduler.swift
//  ios to do app
//
//  Created by Max on 20.01.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import NotificationCenter
import Foundation
import WidgetKit

struct NotificationUtility{
    
    public static func openSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
            UIApplication.shared.open(appSettings)
        }
    }
    
    public static func incrementReminderModalAppearanceCount() {
        let defaults = UserDefaults.standard
        var count = NotificationUtility.getReminderModalAppearanceCount()
        count += 1

        defaults.set(count, forKey: "reminderModalAppearanceCount")

    }

    public static func getReminderModalAppearanceCount() -> Int {
        let defaults = UserDefaults.standard
        if let count = defaults.value(forKey: "reminderModalAppearanceCount") as? Int {

            return count
        } else {
            defaults.set(0, forKey: "reminderModalAppearanceCount")
            return 0
        }
    }
    
    public static func getDontShowRemindersModal() -> Bool {
        if UserDefaults.standard.value(forKey: "dontShowRemindersModal") == nil {
            UserDefaults.standard.set(false, forKey: "dontShowRemindersModal")
        }
        return UserDefaults.standard.bool(forKey: "dontShowRemindersModal")
    }
    
    public static func setDontShowRemindersModal() {
        UserDefaults.standard.set(true, forKey: "dontShowRemindersModal")
    }
    

    
    public static func hasPermissions(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    public static func didAskForNotificationPermissions() -> Bool {
        if UserDefaults.standard.value(forKey: "didAskForNotificationPermissions") == nil { // 1
            UserDefaults.standard.set(false, forKey: "didAskForNotificationPermissions") // 2
        }
        return UserDefaults.standard.bool(forKey: "didAskForNotificationPermissions")
    }
    
    public static func askForNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let _ = error {
                // Handle the error here.
                return
            }
            UserDefaults.standard.set(true, forKey: "didAskForNotificationPermissions")

            // Enable or disable features based on the authorization.
        }
    }
    
    private static func scheduleSingleNotification(date : Date, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
    
        
        if (date.timeIntervalSinceNow.isLessThanOrEqualTo(0)) {
            // already in the past
            return
        }
      
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("scheduled: ")
                print(title)
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.day, .hour, .minute, .second]
                formatter.unitsStyle = .abbreviated

                let formattedInterval = formatter.string(from: date.timeIntervalSinceNow)
                print(formattedInterval ?? "")
              
            }
        }
    }
    
    private static func scheduleNotifications(todoList: [(String, Todo)]) {
        // Remove all scheduled notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for (entityId, todo) in todoList {
            
            if todo.isCompleted {
                continue
            }
            
            if todo.reminderBeforeDueDate >= 0, let timeInterval = TimeInterval(exactly: -todo.reminderBeforeDueDate * 60) {
         
                self.scheduleSingleNotification(date: todo.dueDate.addingTimeInterval(timeInterval), title: todo.task, body: todo.description)
                
                // only schedule future recurring reminders if no cloned recurring todo already exists:
                if !todoList.contains(where: {(_, todo) in
                    todo.createdByRecurringTodoId == entityId
                }) {
                    if (todo.recurring != .none) {
                        if (todo.recurring != .monthly) {
                            // calculate 7 days/weeks in the future
                            for i in 1...7 {
                                
                                if let recurringInterval = TimeInterval(exactly: 60 * 60 * 24 * (todo.recurring == .daily ? 1 : 7) * i) {
                                    self.scheduleSingleNotification(date: todo.dueDate.addingTimeInterval(recurringInterval), title: todo.task, body: todo.description)
                                }
                            }
                        } else {
                            let calendar = Calendar.current
                            // calculate 6 months
                            for i in 1...6 {
                                
                                if let iMonthsLater = calendar.date(byAdding: .month, value: i, to: todo.dueDate) {
                                    self.scheduleSingleNotification(date: iMonthsLater, title: todo.task, body: todo.description)
                                }
                            }
                        }
                        
                    }
                }
                
            }
            for reminder in todo.reminders {
                self.scheduleSingleNotification(date: reminder.date, title: todo.task, body: todo.description)
            }
        }
    }
    
    static func provideWidgetTimeline(tintColor: String, todoList: [(String, Todo)]) {
        
      var dailyTodosTuple : [(Date, [SimpleTodo])] = []
        
      let calendar = Calendar.current
      let now = calendar.startOfDay(for:  Date())
        
      dailyTodosTuple.append((now, []))
    
       for i in 1...7 {
           let date = calendar.date(byAdding: .day, value: i, to: now)!
           let startOfDay = calendar.startOfDay(for: date)
           dailyTodosTuple.append((startOfDay, []))
       }
        
        
        for (_, todo) in todoList {
            
            for i in 0 ..< dailyTodosTuple.count {
                
                var (dailyTodoDate, dailyTodoTodos) : (Date, [SimpleTodo]) = dailyTodosTuple[i]
                
                if todo.dueDate >= dailyTodoDate && todo.dueDate <= calendar.date(byAdding: .day, value: 1, to: dailyTodoDate)! {
                    dailyTodoTodos.append(SimpleTodo(task: todo.task, isCompleted: todo.isCompleted, color: "\(tintColor)"))
                    dailyTodosTuple[i] = (dailyTodoDate, dailyTodoTodos)
                    break
                }
            }
            
        }
        
        var dailyTodos : [DailyTodo] = []
        
        for (dayDate, dayTodos) in dailyTodosTuple {
            
            let sortedTodos = dayTodos.sorted(by: {(lhs, rhs) in
                !lhs.isCompleted
            })
            
           
            dailyTodos.append(DailyTodo(date: dayDate, dailyTodoList: sortedTodos))
        }
        
        let upComingDays = UpcomingDays(dailyTodos: dailyTodos)
        
        do {
            let jsonData = try JSONEncoder().encode(upComingDays)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            
            if let defaults = UserDefaults(suiteName: "group.com.iostodoapp") {
                defaults.setValue(jsonString, forKey: "widget_upcoming_days")

            }
        } catch {
            print(error)
        }
        
        WidgetCenter.shared.reloadAllTimelines()

    }
    
    
    static func schedule(tintColor : String) async {
        
        let db = Firestore.firestore()
        let auth = Auth.auth()
        
        guard let currentUserId = auth.currentUser?.uid else{
            return
        }
        
        
        
        let userTodosQuery = db.collection("todos").whereField("userId", in: [currentUserId])
        
        userTodosQuery.addSnapshotListener { querySnapshot, error in
            if error != nil {
                return
            }
            
            do{
                let docs = try querySnapshot?.documents.map({ docSnapshot in
                    return (docSnapshot.documentID, try docSnapshot.data(as: Todo.self))
                })
                let todoList: [(String, Todo)] = docs!
                
                // schedule notifications if possible
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                    if settings.authorizationStatus == .authorized {
                        // The user has granted permission to send notifications
                        print("Has permissions to send notifications")
                        self.scheduleNotifications(todoList: todoList)
                    }
                    
                    else {
                        print("No permissions to send notifications")
                    }
                }
                
                // provide timeline for today-widget
                provideWidgetTimeline(tintColor: tintColor, todoList: todoList)
                
            } catch {
                
            }
            
        }
        
        
        // recurring
        // dueDate
        //
        
    }
    
    public static func getRemindMeBeforeDueDateDescription(minutes : Int) -> String {
        let _minutes = minutes > 0 ? minutes : -minutes
        
        if (_minutes < 60) {
            return "\(_minutes) \(_minutes > 1 ? "minutes" : "minute")"
        }
        if (minutes < 1440) {
            return "\(_minutes / 60) \((_minutes / 60) > 1 ? "hours" : "hour")"
        }

        return "\(_minutes / 1440) \((_minutes / 1440) > 1 ? "days" : "day")"
        
    }
    
}



struct UpcomingDays: Decodable, Encodable {
    let dailyTodos: [DailyTodo]
}

struct DailyTodo: Decodable, Encodable {
    let date: Date
    var dailyTodoList: [SimpleTodo]
}

struct SimpleTodo: Decodable, Encodable {
    let task : String
    let isCompleted : Bool
    let color : String
}
