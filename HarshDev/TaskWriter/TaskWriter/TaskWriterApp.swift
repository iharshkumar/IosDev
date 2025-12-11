//
//  TaskWriterApp.swift
//  TaskWriter
//
//  Created by BATCH02L1 on 11/12/25.
//

import SwiftUI
import SwiftData
@main
struct TaskTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for:[Task.self])
        }
    }
}
