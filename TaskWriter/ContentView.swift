//
//  ContentView.swift
//  TaskTracker
//
//

import SwiftUI
import SwiftData

@Model
class Task{
    var title: String
    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
    
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var newTaskTitle: String = ""
    @Query var Tasks: [Task]
    var body: some View {
        VStack {
            NavigationView{
                HStack{
                    TextField("Enter new task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: addTask){
                        Text("ADD")
                    }
                    
                }
                List{
                    HStack{
                        Text(task.title)
                        Spacer()
                        Button(action: {
                            toggleTaskCompletion(task)
                        }){
                            Image(systemName: task.isCompleted ? )
                        }
                    }
                }

            }
            
            
        }
        
        
        .padding()
    }
    
    func addTask(){
        if newTaskTitle.isEmpty{
            DispatchQueue.main.async{
                DispatchQueue.main.async{
                    modelContext.insert(Task(title: newTaskTitle))
                    try? modelContext.save()
                    newTaskTitle = ""
                }
            }
        }
        
        func toggleTaskCompletion(_ task: Task){
            task.isCompleted.toggle()
            try? modelContext.save()
        }
    }
    
    
    func deleteTask(at offsets: IndexSet){
        for index in offsets{
            let task = Tasks[index]
            modelContext.delete(task)
            
        }
        try? modelContext.save()
    }
}
#Preview {
    ContentView()
}
