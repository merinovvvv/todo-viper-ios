//
//  TaskDetailRouter.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import UIKit

final class TaskDetailRouter: TaskDetailRouterInput {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func close() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
