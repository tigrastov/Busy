import SwiftUI

struct MediumView: View {
    
    var entry: SimpleEntry?
    var body: some View {
        VStack {
            Text(monthFormatter.string(from: entry!.date))
                .font(.system(size: 12)).fontWeight(.semibold)
            GridCalendar(for: entry!.date)
        }
        //.widgetURL(URL(string: "myapp//todo/\(entry.todos.first?.id ?? 0)"))
        .widgetURL(URL(string: ""))
    }
}


