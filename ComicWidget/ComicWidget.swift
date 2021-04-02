//
//  ComicWidget.swift
//  ComicWidget
//
//  Created by Nitin Seshadri on 3/15/21.
//

import WidgetKit
import SwiftUI

// https://levelup.gitconnected.com/building-a-widget-in-swiftui-81e949185a95
// https://swiftrocks.com/ios-14-widget-tutorial-mini-apps

// Placeholder Comic instance
let placeholderComic: Comic = Comic(num: 1000, title: "1000 Comics", img: "https://imgs.xkcd.com/comics/1000_comics.png")

// Timeline
struct Provider: TimelineProvider {
    var loader = ComicController()

    // Placeholder view (in transient situations)
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), comic: placeholderComic)
    }

    // Snapshot view (in widget gallery screen)
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        loader.getComic { (comic) in
            let entry = SimpleEntry(date: Date(), comic: comic)
            completion(entry)
        }
    }

    // Timeline (main sauce)
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)! // Refresh after one hour

        loader.getComic { (comic) in
            // Generate the widget's timeline.
            let entry = SimpleEntry(date: currentDate, comic: comic)
            entries.append(entry)
            
            let timeline = Timeline(entries: entries, policy: .after(refreshDate))
            completion(timeline)
        }
    }
}

// Timeline entry struct
struct SimpleEntry: TimelineEntry {
    var date: Date
    var comic: Comic
}

// The widget view
struct ComicWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Image(uiImage: entry.comic.uiImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 96, height: 96)
                    .cornerRadius(4)
                
                Spacer()
                
                Text("#\(entry.comic.num):")
                    .font(.caption2).bold()
                Text("\(entry.comic.title)")
                    .font(.caption2).bold()
            }
            
            Spacer()
        }
        .padding()
    }
}

// Widget main and configuration
@main
struct ComicWidget: Widget {
    let kind: String = "ComicWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ComicWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("WidgetBackground"))
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("xkcd Widget")
        .description("Display the latest xkcd comic.")
    }
}

struct ComicWidget_Previews: PreviewProvider {
    static var previews: some View {
        ComicWidgetEntryView(entry: SimpleEntry(date: Date(), comic: placeholderComic))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
