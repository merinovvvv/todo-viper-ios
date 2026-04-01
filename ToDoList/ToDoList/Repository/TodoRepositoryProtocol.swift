//
//  TodoRepositoryProtocol.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

protocol TodoRepositoryProtocol {
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void)
    func saveTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void)
    func updateTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTodo(id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
}
