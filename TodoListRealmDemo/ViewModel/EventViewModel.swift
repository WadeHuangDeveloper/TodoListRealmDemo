//
//  EventViewModel.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import Foundation
import Combine

protocol EventViewModel {
    var event: PassthroughSubject<TaskRepositoryEvent, TaskRepositoryError> { get }
}
