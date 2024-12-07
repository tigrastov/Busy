
import SwiftUI

struct CustomFilteringDataView<Content: View>: View {
    var content: ([Action], [Action]) -> Content
    @FetchRequest private var result: FetchedResults<Action>
    @Binding private var filterDate: Date
    init(filterDate: Binding<Date>, @ViewBuilder content: @escaping ([Action],[Action]) -> Content) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: filterDate.wrappedValue)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@" , argumentArray:  [startOfDay, endOfDay])
        _result = FetchRequest(entity: Action.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Action.date, ascending: false)], predicate: predicate, animation: .easeInOut(duration: 0.25))
        self.content = content
        self._filterDate = filterDate
    }
    
    var body: some View {
        content(separateTasks().0, separateTasks().1)
            .onChange(of: filterDate) { newValue in
                
                //Clearing Old Predicate
                result.nsPredicate = nil
                
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: newValue)
                let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
                let predicate = NSPredicate(format: "date >= %@ AND date <= %@" , argumentArray:  [startOfDay, endOfDay])
                
                
                // Assigning New Predicate
                result.nsPredicate = predicate
            }
    }
    
    func separateTasks() -> ([Action], [Action]) {
        let pendingTasks = result.filter { !$0.isCompleted}
        let completedTasks = result.filter { $0.isCompleted}
        return (pendingTasks, completedTasks)
    }
}

#Preview {
    ContentView()
}

