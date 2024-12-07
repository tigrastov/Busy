

import SwiftUI
//let screen = UIScreen.main.bounds
@main
struct BusyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .background(Color.red)
        }
    }
}
