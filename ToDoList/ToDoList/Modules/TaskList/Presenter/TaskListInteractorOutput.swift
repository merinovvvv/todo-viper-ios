//
//  TaskListInteractorOutput.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

protocol TaskListInteractorOutput: AnyObject {
    func didFetchTodos(_ todos: [Todo])
    func didUpdateTodo(_ todo: Todo)
    func didDeleteTodo(id: UUID)
    func didFailWithError(_ error: Error)
}
