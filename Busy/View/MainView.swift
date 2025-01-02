
import SwiftUI

struct MainView: View {
    //View properties
    @Environment(\.self) private var env
    @State private var filterDate: Date = .init()
    @State private var showPendingTasks: Bool = true
    @State private var showCompletedTasks: Bool = true
    @State private var showAPIView: Bool = true
    
    private let showViewKey = "showViewState"
    
    var body: some View {
        
    VStack {
        
        List{
            if showAPIView{
                APIView()
            }
            
            
            DatePicker(selection: $filterDate, displayedComponents: [.date]) {
                
            }
            .tint(.orange)
            .labelsHidden()
            .datePickerStyle(GraphicalDatePickerStyle())
            .foregroundStyle(.red)
            
            CustomFilteringDataView(filterDate: $filterDate) { pendingTasks, completedTasks in
                DisclosureGroup(isExpanded: $showPendingTasks) {
                    //Custom Core data filter view, wich will Display only Pending Tasks on this day
                    if pendingTasks.isEmpty {
                        Text("No tasks")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }else{
                        ForEach(pendingTasks) {
                            
                            TaskRow(task: $0, isPending: true)
                        }
                    }
                    
                } label: {
                    HStack{
                        Text("Pending Tasks")
                    }
                    
                    Text("\(pendingTasks.isEmpty ? "" : "(\(pendingTasks.count))")").font(.system(size: 15))
                        .font(.headline).fontWeight(.semibold)
                        //.foregroundStyle(.gray)
                }
                .tint(.orange)
                DisclosureGroup(isExpanded: $showCompletedTasks) {
                    //Custom Core data filter view, wich will Display only Completed Tasks on this day
                    if completedTasks.isEmpty {
                        //
                    }else{
                        ForEach(completedTasks) {
                            
                            TaskRow(task: $0, isPending: false)
                        }
                    }
                    
                } label: {
                    HStack{
                        /*
                        Text ("Completed Tasks \(completedTasks.isEmpty ? "" : "(\(completedTasks.count))")")
                         */
                        Text ("Completed Tasks")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text("\(completedTasks.isEmpty ? "" : "(\(completedTasks.count))")").font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                }
                .tint(.orange)
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    //Просто открытие Pending task View
                    // Then Adding n Empty Task
                    
                    do{
                        let task = Action(context: env.managedObjectContext)
                        task.id = .init()
                        task.title = ""
                        task.date = filterDate
                        task.isCompleted = false
                        
                        try env.managedObjectContext.save()
                        showPendingTasks = true
                        
                    }catch{
                        print(error.localizedDescription)
                    }
                    
                    
                } label: {
                    
                    HStack{
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                        
                        Text("New Task")
                    }
                    .fontWeight(.bold)
                }
                .tint(.orange)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            
            ToolbarItem(placement: .bottomBar){
                
                Button {
                    withAnimation {
                        showAPIView.toggle()
                        saveShowViewState(showAPIView)
                    }
                    
                    
                } label: {
                    HStack{
                        Image(systemName: showAPIView ? "minus.circle.fill" : "plus.circle.fill")
                            .font(.title3).fontWeight(.bold)
                        Text(
                             
                            showAPIView ?
                             """
                             Hide  Useful Information
                             """ : """
                             Show Useful Information
                             """
                                
                        ).font(.system(size: 12))
                    }
                }.tint(.orange).frame(maxWidth: .infinity, alignment: .trailing)
                
            }
            
            
        }
    }
    .onAppear{
        showAPIView = loadShowViewState()
    }
        
        
    
    }
        
    private func saveShowViewState(_ value: Bool) {
            UserDefaults.standard.set(value, forKey: showViewKey)
        }
    
    private func loadShowViewState() -> Bool {
           return UserDefaults.standard.bool(forKey: showViewKey)
       }
    
    }

#Preview {
    ContentView()
}

struct TaskRow: View{
    @ObservedObject var task: Action
    var isPending: Bool
    //View Properties
    @Environment(\.self) private var env
    @FocusState private var showKeyboard: Bool
    var body: some View{
        HStack(spacing: 12){
            Button{
                task.isCompleted.toggle()
                save()
                
                
            }label:{
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundStyle(.orange)
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 4){
                TextField("Enter Task", text: .init(get: {
                    return task.title ?? ""
                }, set: { value in
                    task.title = value
                })
                )
                .focused($showKeyboard)
                .onSubmit {
                    removeEmptyTask()
                    save()
                }
                
                
                //.foregroundStyle( isPending ? .primary : .tertiary)
                .strikethrough(!isPending, pattern: .solid, color: .orange)
                
                
                
                
                 // Custom Date picker
                Text((task.date ?? .init()).formatted(date: .omitted, time: .shortened))
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .overlay {
                        DatePicker(selection: .init(get: {
                            return task.date ?? .init()
                        },
                            set: { value in
                            task.date = value
                            save()
                        }),
                                   displayedComponents: [.hourAndMinute]) {
                        }
                                   .labelsHidden()
                        
                        
                                  // .offset(x: 100 )
                                   .blendMode(.destinationOver)
                        
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear{
            if (task.title ?? "").isEmpty{
                showKeyboard = true
            }
        }
        
        .onDisappear{
            removeEmptyTask()
            save()
            
        }
        
        
        .onChange(of: env.scenePhase) { newValue in
            if newValue != .active{
                showKeyboard = false
                DispatchQueue.main.async {
                    removeEmptyTask()
                    save()
                }
            }
        }
    
        // Swipe to Deleting
        
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive){
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    env.managedObjectContext.delete(task)
                    save()
                }
            } label: {
                Image(systemName: "trash.fill")
            }
        }
        
    }
    
    func save(){
        do{
           try env.managedObjectContext.save()
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func removeEmptyTask(){
        if (task.title ?? "").isEmpty{
            //Removing
            env.managedObjectContext.delete(task)
        }
    }
    
}


