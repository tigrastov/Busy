import WidgetKit
import SwiftUI

@main
struct Busy: Widget {
    
    let kind: String = "Busy as bees"
    
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CalendarWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CalendarWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemMedium,  .systemLarge, .accessoryInline, .accessoryCircular, .accessoryRectangular])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

