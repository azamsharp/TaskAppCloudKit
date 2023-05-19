//
//  TodoListScreen.swift
//  TaskTracker
//
//  Created by Mohammad Azam on 1/3/23.
//

import SwiftUI

enum FilterOptions: String, CaseIterable, Identifiable {
    case all
    case completed
    case incomplete
}

extension FilterOptions {
    
    var id: String {
        rawValue
    }
    
    var displayName: String {
        rawValue.capitalized
    }
}

struct TodoListScreen: View {
    
    @EnvironmentObject private var model: Model 
    @State private var taskTitle: String = ""
    @State private var filterOption: FilterOptions = .all
    
    private var filteredTaskItems: [TaskItem] {
        model.filterTaskItems(by: filterOption)
    }
    
    var body: some View {
        VStack {
            TextField("Enter task", text: $taskTitle)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    // add validation TODO
                    let taskItem = TaskItem(title: taskTitle, dateAssigned: Date())
                    Task {
                        try await model.addTask(taskItem: taskItem)
                    }
                }
            
            // segmented control
            Picker("Select", selection: $filterOption) {
                ForEach(FilterOptions.allCases) { option in
                    Text(option.displayName).tag(option)
                }
            }.pickerStyle(.segmented)
            
            TaskListView(taskItems: filteredTaskItems)
            
            Spacer()
        }
        .task {
            do {
                try await model.populateTasks()
            } catch {
                print(error)
            }
        }
        .padding()
    }
}

struct TodoListScreen_Previews: PreviewProvider {
    static var previews: some View {
        TodoListScreen().environmentObject(Model())
    }
}
