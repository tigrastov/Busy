
import SwiftUI

struct LargeView: View {
    var entry: SimpleEntry?
    var body: some View {
        VStack{
            Text(monthFormatter.string(from: entry!.date))
                .font(.system(size: 12)).fontWeight(.semibold).padding(.top,5)
            GridCalendar(for: entry!.date)
        }
    }
}

