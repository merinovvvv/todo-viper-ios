//
//  TaskDetailViewInput.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

protocol TaskDetailViewInput: AnyObject {
    func showTodo(_ viewModel: TaskDetailViewModel)
    func updateCompletion(isCompleted: Bool)
    func showError(_ message: String)
}
