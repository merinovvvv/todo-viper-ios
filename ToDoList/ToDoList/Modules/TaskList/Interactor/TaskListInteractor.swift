//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

final class TaskListInteractor: TaskListInteractorInput {
    
    private weak var presenter: TaskListInteractorOutput?
    private let repository: TodoRepositoryProtocol
    
    init(
        presenter: TaskListInteractorOutput,
        repository: TodoRepositoryProtocol
    ) {
        self.presenter = presenter
        self.repository = repository
    }
    
    func fetchTodos() {
        repository.fetchTodos { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let todos):
                DispatchQueue.main.async {
                    self.presenter?.didFetchTodos(todos)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailWithError(error)
                }
            }
        }
    }
    
    func updateTodo(_ todo: Todo) {
        repository.updateTodo(todo) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.presenter?.didUpdateTodo(todo)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailWithError(error)
                }
            }
        }
    }
    
    func deleteTodo(id: UUID) {
        repository.deleteTodo(id: id) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.presenter?.didDeleteTodo(id: id)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailWithError(error)
                }
            }
        }
    }
}
