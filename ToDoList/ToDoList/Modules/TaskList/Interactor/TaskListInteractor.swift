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
    private var todos: [Todo] = []
    
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
                self.todos = todos
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
    
    func deleteTodo(id: UUID) {
        repository.deleteTodo(id: id) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                self.todos.removeAll { $0.id == id }
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
    
    func searchTodos(query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            DispatchQueue.main.async {
                self.presenter?.didFetchTodos(self.todos)
            }
            return
        }
        
        let filteredTodos = todos.filter { todo in
            todo.title.localizedCaseInsensitiveContains(trimmedQuery) ||
            todo.description.localizedCaseInsensitiveContains(trimmedQuery)
        }
        
        DispatchQueue.main.async {
            self.presenter?.didFetchTodos(filteredTodos)
        }
    }
}
