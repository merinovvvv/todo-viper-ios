//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import UIKit

final class TaskListRouter: TaskListRouterInput {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func navigateToTaskDetail(todo: Todo?) {
        let detailViewController = TaskDetailAssembly.build(todo: todo)
        
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
