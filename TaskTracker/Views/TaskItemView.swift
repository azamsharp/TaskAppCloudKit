//
//  TaskItemView.swift
//  TaskTracker
//
//  Created by Mohammad Azam on 1/3/23.
//

import SwiftUI

struct TaskItemView: View {
    
    let taskItem: TaskItem
    let onUpdate: (TaskItem) -> Void
    
    var body: some View {
        HStack {
            Text(taskItem.title)
            Spacer()
            Image(systemName: taskItem.isCompleted ? "checkmark.square": "square")
                .onTapGesture {
                    var taskItemToUpdate = taskItem
                    taskItemToUpdate.isCompleted = !taskItem.isCompleted
                    onUpdate(taskItemToUpdate)
                }
        }
    }
}

struct TaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        TaskItemView(taskItem: TaskItem(title: "Mow the lawn", dateAssigned: Date()), onUpdate: { _ in })
    }
}
