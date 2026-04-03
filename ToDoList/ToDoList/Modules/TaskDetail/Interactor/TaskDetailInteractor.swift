//
//  TaskDetailInteractor.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

final class TaskDetailInteractor: TaskDetailInteractorInput {
    private weak var presenter: TaskDetailInteractorOutput?
    private let repository: TodoRepositoryProtocol
    
    init(
        presenter: TaskDetailInteractorOutput,
        repository: TodoRepositoryProtocol
    ) {
        self.presenter = presenter
        self.repository = repository
    }
    
    func saveTodo(_ todo: Todo) {
        repository.saveTodo(todo) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.presenter?.didSaveTodo()
                case .failure(let error):
                    self.presenter?.didFailWithError(error)
                }
            }
        }
    }
    
    func updateTodo(_ todo: Todo) {
        repository.updateTodo(todo) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.presenter?.didSaveTodo()
                case .failure(let error):
                    self.presenter?.didFailWithError(error)
                }
            }
        }
    }
}
