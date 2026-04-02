//
//  TodoRepository.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

final class TodoRepository: TodoRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    
    init(networkService: NetworkServiceProtocol,
         coreDataService: CoreDataServiceProtocol) {
        self.networkService = networkService
        self.coreDataService = coreDataService
    }
    
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        if coreDataService.isStoreEmpty() {
            networkService.fetchTodos { result in
                switch result {
                case .success(let response):
                    let todos = response.todos.map { $0.toDomain() }
                    for todo in todos {
                        let saveResult = self.coreDataService.saveTodo(todo)
                        if case .failure(let error) = saveResult {
                            completion(.failure(error))
                            return
                        }
                    }
                    completion(.success(todos))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            let result = self.coreDataService.fetchTodos()
            switch result {
            case .success(let todos):
                let domainTodos = todos.map { $0.toDomain() }
                completion(.success(domainTodos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void) {
        let result = coreDataService.saveTodo(todo)
        switch result {
        case .success:
            completion(.success(()))
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func updateTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void) {
        let result = coreDataService.updateTodo(todo)
        switch result {
        case .success:
            completion(.success(()))
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func deleteTodo(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let result = coreDataService.deleteTodo(id: id)
        switch result {
        case .success:
            completion(.success(()))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
