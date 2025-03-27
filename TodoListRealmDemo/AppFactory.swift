//
//  AppFactory.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import Foundation
import UIKit

struct AppFactory {
    static func makeTaskListViewController() -> UIViewController {
        let repository = TaskRepository()
        let viewModel = TaskListViewControllerViewModel(repository: repository)
        let viewController = TaskListViewController(viewModel: viewModel)
        return viewController
    }
}
