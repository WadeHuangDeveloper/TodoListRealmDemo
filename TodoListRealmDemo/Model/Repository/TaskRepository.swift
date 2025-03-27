//
//  TaskRepository.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import Foundation

class TaskRepository: TaskRepositoryProtocol {
    func read(task: TaskObject) throws -> TaskObject? {
        do {
            let task: TaskObject? = try RealmService.shared.read(primaryKey: task.id)
            return task
        } catch {
            throw error
        }
    }
    
    func readAll() throws -> [TaskObject] {
        do {
            var tasks: [TaskObject] = try RealmService.shared.readAll()
            tasks = tasks.sorted { $0.createTimestamp > $1.createTimestamp }
            return tasks
        } catch {
            throw error
        }
    }
    
    func create(title: String) throws {
        do {
            let task = TaskObject()
            task.title = title
            try RealmService.shared.create(object: task)
        } catch {
            throw error
        }
    }
    
    func update(task: TaskObject, title: String? = nil, isDone: Bool? = nil) throws {
        do {
            let newTask = TaskObject()
            newTask.id = task.id
            newTask.title = title != nil ? title! : task.title
            newTask.isDone = isDone != nil ? isDone! : task.isDone
            newTask.createTimestamp = task.createTimestamp
            if task.isDone == false && isDone == true {
                newTask.finishTimestamp = .now
            } else if task.isDone == true && isDone == false {
                newTask.finishTimestamp = nil
            } else {
                newTask.finishTimestamp = task.finishTimestamp
            }
            try RealmService.shared.update(object: newTask)
        } catch {
            throw error
        }
    }
    
    func delete(task: TaskObject) throws {
        do {
            try RealmService.shared.delete(type: TaskObject.self, primaryKey: task.id)
        } catch {
            throw error
        }
    }
}
