

import SwiftUI
//let screen = UIScreen.main.bounds
@main
struct BusyApp: App {
    @State var isLoading: Bool = true
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
            if isLoading {
                LoadingView(isLoading: $isLoading)
            } else {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            
                
            
            
        }
    }
}
