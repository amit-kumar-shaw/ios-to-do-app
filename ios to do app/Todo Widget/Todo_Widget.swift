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
        SimpleEntry(date: Date(), upcomingTodos: [SimpleTodo(task: "Example task 1", isCompleted: true, color: "#025ee8"), SimpleTodo(task: "Example task 2", isCompleted: true, color: "#18eb09"), SimpleTodo(task: "Example task 3", isCompleted: true, color: "#e802e0"),], configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
     
        

        completion(SimpleEntry(date: Date(), upcomingTodos: [SimpleTodo(task: "Example task 1", isCompleted: true, color: "#025ee8"), SimpleTodo(task: "Example task 2", isCompleted: true, color: "#18eb09"), SimpleTodo(task: "Example task 3", isCompleted: true, color: "#e802e0")], configuration: ConfigurationIntent()))

    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var jsonString = ""
        if let jS : String = UserDefaults(suiteName: "group.com.iostodoapp")?.string(forKey: "widget_upcoming_days")
        {
            jsonString = jS
        }

        let jsonData = jsonString.data(using: .utf8)!
        
        var decodedUpComingDays = UpcomingDays(dailyTodos: [])
        
        do { decodedUpComingDays = try JSONDecoder().decode(UpcomingDays.self, from: jsonData) }
        catch _ {}
        
        var entries: [SimpleEntry] = []
        
        for day in decodedUpComingDays.dailyTodos {
            
            let entry = SimpleEntry(date:day.date, upcomingTodos: day.dailyTodoList, configuration: configuration)
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
        .configurationDisplayName("Today's Tasks")
        .description("This widget displays all the tasks due for the current day, making it easy to stay on top of your to-do list and get things done.")
    }
}

struct Todo_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Todo_WidgetEntryView(entry: SimpleEntry(date: Date(), upcomingTodos: [], configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
