//
//  TaskTrackerApp.swift
//  TaskTracker
//
//  Created by Mohammad Azam on 1/3/23.
//

import SwiftUI

@main
struct TaskTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListScreen().environmentObject(Model())
        }
    }
}
