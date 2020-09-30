//
//  Trail_Lab_Widget.swift
//  Trail Lab Widget
//
//  Created by Nika on 9/17/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

//struct Provider: IntentTimelineProvider {
////    func placeholder(in context: Context) -> SimpleEntry {
////        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
////    }
//
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
//        let entry = SimpleEntry(date: Date(), size: context.family)
//        completion(entry)
//    }
//
//    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), configuration: configuration)
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
//        let entry = SimpleEntry(date: Date(), size: context.family)
//        let timeline = Timeline(entries: [entry], policy: .atEnd)
//        completion(timeline)
//    }

//    struct SimpleEntry: TimelineEntry {
//        let date: Date
//        let size: WidgetFamily
//    }

//    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}//

struct Provider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), size: context.family)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = SimpleEntry(date: Date(), size: context.family)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), size: context.family)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let size: WidgetFamily
}

struct Trail_Lab_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        GraphTileWidget()
    }
}

@main
struct Trail_Lab_Widget: Widget {
    let kind: String = "Trail_Lab_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Trail_Lab_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Trail Lab")
        .description("Weekly progress widget.")
    }
}

//struct Trail_Lab_Widget_Previews: PreviewProvider {
//    static var previews: some View {
//        Trail_Lab_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}



class WidgetDataManager {

    func getData() -> [BarGraphModel] {
        print("Fetching data...")
        guard let dataStore = UserDefaults.shared,
              let data = dataStore.object(forKey:BarGraphModelWidget.sharedKey) as? Data else {
            print("Failed to read data for Widget")
            return []
        }

        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode([BarGraphModelWidget].self, from: data) else {
            print("Failed to decode data for Widget")
            return []
        }

        var bars: [BarGraphModel] = []
        for i in decodedData {

            var gradient = Gradient(stops: [])
            for key in i.c.keys {
                gradient.stops.append(.init(color: ActivityType(rawValue: key)?.color() ?? .blue, location: i.c[key] ?? 0))
            }

            bars.append(BarGraphModel(v: i.v, c: gradient, day: i.day))
        }

        return bars
    }
}
