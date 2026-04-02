//
//  TaskListInteractorOutput.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

protocol TaskListInteractorOutput: AnyObject {
    func didFetchTodos(_ todos: [Todo])
    func didDeleteTodo(id: UUID)
    func didFailWithError(_ error: Error)
}
