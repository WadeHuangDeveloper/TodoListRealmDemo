//
//  TaskObject.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import Foundation
import RealmSwift

class TaskObject: Object {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var title: String = ""
    @Persisted var isDone: Bool = false
    @Persisted var createTimestamp: Date = .now
    @Persisted var finishTimestamp: Date?
}
