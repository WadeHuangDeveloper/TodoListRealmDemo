//
//  TaskRepositoryEvent.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import Foundation

enum TaskRepositoryEvent {
    case read(TaskObject)
    case readAll([TaskObject])
    case create(TaskObject)
    case update(TaskObject)
    case delete(TaskObject)
}

enum TaskRepositoryError: Error {
    case readAll(Error)
    case create(Error)
    case update(Error)
    case delete(Error)
}
