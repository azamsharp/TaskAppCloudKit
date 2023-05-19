//
//  Model.swift
//  TaskTracker
//
//  Created by Mohammad Azam on 1/3/23.
//

import Foundation
import CloudKit

// AGGREGATE MODEL
@MainActor
class Model: ObservableObject {
    
    private var db = CKContainer.default().privateCloudDatabase
    @Published private var tasksDictionary: [CKRecord.ID: TaskItem] = [:]
    
    var tasks: [TaskItem] {
        tasksDictionary.values.compactMap { $0 }
    }
    
    func addTask(taskItem: TaskItem) async throws {
        let record = try await db.save(taskItem.record)
        guard let task = TaskItem(record: record) else { return }
        tasksDictionary[task.recordId!] = task
    }
    
    func updateTask(editedTaskItem: TaskItem) async throws {
        
        tasksDictionary[editedTaskItem.recordId!]?.isCompleted = editedTaskItem.isCompleted
        
        do {
            let record = try await db.record(for: editedTaskItem.recordId!)
            record[TaskRecordKeys.isCompleted.rawValue] = editedTaskItem.isCompleted
            try await db.save(record)
        } catch {
            tasksDictionary[editedTaskItem.recordId!] = editedTaskItem
            // throw an error to tell the user that something has happened and the update was not successfull
        }
    }
    
    func deleteTask(taskItemToBeDeleted: TaskItem) async throws {
        
        tasksDictionary.removeValue(forKey: taskItemToBeDeleted.recordId!)
        
        do {
            let _ = try await db.deleteRecord(withID: taskItemToBeDeleted.recordId!)
        } catch {
            tasksDictionary[taskItemToBeDeleted.recordId!] = taskItemToBeDeleted
            print(error)
        }
        
    }
    
    func populateTasks() async throws {
        
        let query = CKQuery(recordType: TaskRecordKeys.type.rawValue, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "dateAssigned", ascending: false)]
        let result = try await db.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        
        records.forEach { record in
            tasksDictionary[record.recordID] = TaskItem(record: record)
        }
    }
    
    func filterTaskItems(by filterOptions: FilterOptions) -> [TaskItem] {
        switch filterOptions {
            case .all:
                return tasks
            case .completed:
                return tasks.filter { $0.isCompleted }
            case .incomplete:
                return tasks.filter { !$0.isCompleted }
        }
    }
    
}
