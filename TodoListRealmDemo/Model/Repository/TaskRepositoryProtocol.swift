//
//  TaskRepositoryProtocol.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import Foundation

protocol TaskRepositoryProtocol {
    func read(task: TaskObject) throws -> TaskObject?
    func readAll() throws -> [TaskObject]
    func create(title: String) throws
    func update(task: TaskObject, title: String?, isDone: Bool?) throws
    func delete(task: TaskObject) throws
}
