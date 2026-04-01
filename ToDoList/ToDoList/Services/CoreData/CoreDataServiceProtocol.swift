//
//  CoreDataServiceProtocol.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 31.03.26.
//

import Foundation

protocol CoreDataServiceProtocol {
    func fetchTodos() -> Result<[Todo], CoreDataError>
    func saveTodo(_ todo: Todo) -> Result<Void, CoreDataError>
    func updateTodo(_ todo: Todo) -> Result<Void, CoreDataError>
    func deleteTodo(id: UUID) -> Result<Void, CoreDataError>
    func isStoreEmpty() -> Bool
}
