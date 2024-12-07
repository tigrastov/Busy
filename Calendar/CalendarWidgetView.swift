import Foundation
import SwiftUI
import WidgetKit

struct CalendarWidgetView: View {
    var entry: SimpleEntry
   @Environment(\.widgetFamily) var widgetFamily
    var body: some View {
        
        
        /*
        VStack{
            Text("Календарь для \(monthFormatter.string(from: entry.date))")
            
            GridCalendar(for: entry.date).padding(10)
        }
        
        */
        
        switch widgetFamily{
        case .systemLarge: LargeView(entry: entry)
       
        case .systemMedium: MediumView(entry: entry)
        //case .accessoryInline:
            //Text(entry.todos.first?.title ?? "No todos")
        case .accessoryRectangular:
            Gauge(value: 0.7){
                GridCalendar(for: entry.date)
               //Text(entry.date, format: .dateTime.year())
            }.gaugeStyle(.accessoryLinear)
        case .accessoryCircular:
            Gauge(value: 0.7){
               //Text(entry.date, format: .dateTime.year())
                GridCalendar(for: entry.date)
            }.gaugeStyle(.accessoryCircular)
        default: Text("Not implemented")
        }
       
        
    }
}

