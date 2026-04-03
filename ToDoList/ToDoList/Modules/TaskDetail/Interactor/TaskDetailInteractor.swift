//
//  TaskDetailInteractor.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

final class TaskDetailInteractor: TaskDetailInteractorInput {
    
    // MARK: - Dependencies
    
    private weak var presenter: TaskDetailInteractorOutput?
    private let repository: TodoRepositoryProtocol
    
    // MARK: - Init
    
    init(
        presenter: TaskDetailInteractorOutput,
        repository: TodoRepositoryProtocol
    ) {
        self.presenter = presenter
        self.repository = repository
    }
    
    // MARK: - Methods
    
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
