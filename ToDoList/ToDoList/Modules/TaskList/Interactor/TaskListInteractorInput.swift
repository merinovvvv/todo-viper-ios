//
//  TaskListInteractorInput.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

protocol TaskListInteractorInput: AnyObject {
    func fetchTodos()
    func updateTodo(_ todo: Todo)
    func deleteTodo(id: UUID)
}
