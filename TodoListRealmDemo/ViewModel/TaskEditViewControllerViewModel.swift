//
//  TaskEditViewControllerViewModel.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import Foundation
import Combine

class TaskEditViewControllerViewModel: EventViewModel {
    @Published var editIsDone: Bool
    var event = PassthroughSubject<TaskRepositoryEvent, TaskRepositoryError>()
    let task: TaskModel
    let repository: TaskRepositoryProtocol
    
    init(task: TaskModel, repository: TaskRepositoryProtocol) {
        self.editIsDone = task.object.isDone
        self.task = task
        self.repository = repository
    }
    
    func update(task: TaskObject, title: String, isDone: Bool) {
        do {
            try repository.update(task: task, title: title, isDone: isDone)
            if let newTask = try repository.read(task: task) {
                event.send(.update(newTask))
            } else {
                throw NSError(domain: "\(#function)", code: 404, userInfo: [NSLocalizedDescriptionKey: "\(#function) failed"])
            }
        } catch {
            event.send(completion: .failure(.update(error)))
        }
    }
    
    func delete(task: TaskObject) {
        do {
            try repository.delete(task: task)
            event.send(.delete(task))
        } catch {
            event.send(completion: .failure(.delete(error)))
        }
    }
}
