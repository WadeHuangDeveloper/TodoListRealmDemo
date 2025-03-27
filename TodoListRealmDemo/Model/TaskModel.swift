//
//  TaskModel.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/27.
//

import Foundation

class TaskModel {
    let object: TaskObject
    
    init(object: TaskObject) {
        self.object = object
    }
    
    static func ConvertObjectsToModels(_ objects: [TaskObject]) -> [TaskModel] {
        return objects.map { TaskModel(object: $0) }
    }
}
