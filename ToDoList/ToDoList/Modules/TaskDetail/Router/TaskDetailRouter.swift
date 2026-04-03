//
//  TaskDetailRouter.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import UIKit

final class TaskDetailRouter: TaskDetailRouterInput {
    
    // MARK: - Properties
    
    weak var viewController: UIViewController?
    
    // MARK: - Init
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    // MARK: - Methods
    
    func close() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
