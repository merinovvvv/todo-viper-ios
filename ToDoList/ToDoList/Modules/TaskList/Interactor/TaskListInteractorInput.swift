//
//  TaskListInteractorInput.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

protocol TaskListInteractorInput: AnyObject {
    func fetchTodos()
    func deleteTodo(id: UUID)
    func searchTodos(query: String)
}
