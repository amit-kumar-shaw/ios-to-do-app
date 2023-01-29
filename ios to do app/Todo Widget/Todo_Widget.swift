//
//  Todo_Widget.swift
//  Todo Widget
//
//  Created by Max on 28.01.23.
//

import WidgetKit
import SwiftUI
import Intents


struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), upcomingTodos: [], configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), upcomingTodos: [], configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var todoList : [SimpleTodo] = []
        todoList.append(SimpleTodo(task: "Answer me 2", isCompleted: true, color: "#ff0000"))
        todoList.append(SimpleTodo(task: "Code app", isCompleted: false, color: "#ff0000"))
        todoList.append(SimpleTodo(task: "Practice piano", isCompleted: false, color: "#ff0000"))
        
        var t : String = "----"
        if let bla : String = UserDefaults(suiteName: "group.com.iostodoapp")?.string(forKey: "LOL")
        {
            t = bla
        }
            
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let dailyTodo = DailyTodo(date: entryDate, dailyTodoList: todoList)
            
            
            let entry = SimpleEntry(date:entryDate, upcomingTodos: dailyTodo.dailyTodoList, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    
    let upcomingTodos : [SimpleTodo]
    let configuration: ConfigurationIntent
}


struct UpcomingDays: Decodable {
    let dailyTodos: [DailyTodo]
}

struct DailyTodo: Decodable {
    let date: Date
    let dailyTodoList: [SimpleTodo]
}

struct SimpleTodo: Decodable {
    let task : String
    let isCompleted : Bool
    let color : String
}


struct Todo_WidgetEntryView : View {
    var entry: Provider.Entry
    var upcomingTodos : [SimpleTodo] = []
    
    init(entry: Provider.Entry) {
        self.entry = entry
        
    
    }
    
    var body: some View {
        TodoWidgetView(upcomingTodos: self.entry.upcomingTodos)
    }
}

struct Todo_Widget: Widget {
    let kind: String = "Todo_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Todo_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Todo Widget")
        .description("This is an example widget.")
    }
}

struct Todo_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Todo_WidgetEntryView(entry: SimpleEntry(date: Date(), upcomingTodos: [], configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
