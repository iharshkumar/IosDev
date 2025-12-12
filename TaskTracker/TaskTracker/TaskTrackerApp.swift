//
//  TaskTrackerApp.swift
//  TaskTracker
//
//  Created by BATCH02L1 on 12/12/25.
//


import SwiftUI
import SwiftData
@main
struct TestTrackerApp: App {
    var body: some Scene {
        let container: ModelContainer = try! ModelContainer(for: Task.self)
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
