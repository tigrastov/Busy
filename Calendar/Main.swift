import WidgetKit
import SwiftUI

@main
struct CalendarWidget: Widget {
    
    let kind: String = "Calendar"
    
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

