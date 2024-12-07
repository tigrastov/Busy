import SwiftUI

struct GridCalendar: View {
    let month: Date
    private let calendar = Calendar.current
    private var days: [Date] = []

    init(for date: Date) {
        self.month = date
        self.days = []

        let range = calendar.range(of: .day, in: .month, for: date)!
        let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        
        
        // Получаем первый день недели месяца
                let firstWeekday = calendar.component(.weekday, from: firstDay)
        // Добавляем пустые ячейки для дней перед первым днем месяца
                let emptyDaysCount = (firstWeekday + 5) % 7
        // Понедельник - это 1, а воскресенье - 7
                for _ in 0..<emptyDaysCount {
                    days.append(Date.distantPast) // Заполнение пустыми датами
                }

        // Заполните массив датами текущего месяца
        for day in 1...range.count {
            if let currentDay = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(currentDay)
            }
        }
    }

    var body: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 7)

        LazyVGrid(columns: columns) {
            // Дни недели
            ForEach([ "Mon", "Tue", "Wed", "Thu", "Fri", "Sat","Sun"], id: \.self) { day in
                Text(day)
                    .font(.system(size: 10)).fontWeight(.bold)
                    
                    .frame(maxWidth: .infinity)
            }

            // Дни месяца
            ForEach(days, id: \.self) { date in
                
                if date != Date.distantPast{
                    Text("\(calendar.component(.day, from: date))")
                       // .foregroundStyle(Color.white)
                        .font(.system(size: 10))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.orange.opacity(0.8))
    .cornerRadius(30)
                }else{
                    Spacer()
                }
                
                
            }
        }
    }
}
