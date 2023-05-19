//
//  TaskListView.swift
//  TaskTracker
//
//  Created by Mohammad Azam on 1/3/23.
//

import SwiftUI

struct TaskListView: View {
    
    let taskItems: [TaskItem]
    @EnvironmentObject private var model: Model
    
    var body: some View {
        List {
            ForEach(taskItems, id: \.recordId) { taskItem in
                TaskItemView(taskItem: taskItem, onUpdate: { editedTask in
                    Task {
                        do {
                            try await model.updateTask(editedTaskItem: editedTask)
                        } catch {
                            print(error)
                        }
                    }
                })
            }.onDelete { indexSet in
                
                guard let index = indexSet.map({ $0 }).last else {
                    return
                }
                
                let taskItem = model.tasks[index]
                Task {
                    do {
                        try await model.deleteTask(taskItemToBeDeleted: taskItem)
                    } catch {
                        print(error)
                    }
                }
                
            }
        }
        
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(taskItems: []).environmentObject(Model())
    }
}
