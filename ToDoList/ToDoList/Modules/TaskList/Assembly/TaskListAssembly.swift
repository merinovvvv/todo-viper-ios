//
//  TaskListAssembly.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import UIKit

final class TaskListAssembly {
    static func build() -> UIViewController {
        let repository = TodoRepository(
            networkService: NetworkService(),
            coreDataService: CoreDataService()
        )

        let router = TaskListRouter()
        let presenter = TaskListPresenter()
        let interactor = TaskListInteractor(presenter: presenter, repository: repository)
        let taskListViewController = TaskListViewController(presenter: presenter)
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = taskListViewController
        
        router.viewController = taskListViewController
        
        return taskListViewController
    }
}
