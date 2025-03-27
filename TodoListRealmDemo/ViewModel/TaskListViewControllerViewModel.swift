//
//  TaskListViewControllerViewModel.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import Foundation
import Combine

class TaskListViewControllerViewModel: EventViewModel {
    @Published var tasks: [TaskModel] = []
    var event = PassthroughSubject<TaskRepositoryEvent, TaskRepositoryError>()
    let repository: TaskRepositoryProtocol
    
    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }
    
    func readAll() {
        do {
            let tasks = try repository.readAll()
            self.tasks = TaskModel.ConvertObjectsToModels(tasks)
            self.event.send(.readAll(tasks))
        } catch {
            event.send(completion: .failure(.readAll(error)))
        }
    }
}
