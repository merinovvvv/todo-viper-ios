//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

final class TaskListPresenter {
    
    // MARK: - Dependencies
    weak var view: TaskListViewInput?
    var interactor: TaskListInteractorInput?
    var router: TaskListRouterInput?
    
    // MARK: - Properties
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()
    private var allTodos: [Todo] = []
    private var visibleTodos: [Todo] = []
    private var currentSearchQuery = ""
        
    // MARK: - Init
    init() { }
}

// MARK: - TaskListViewOutput
extension TaskListPresenter: TaskListViewOutput {
    func viewDidLoad() {
        interactor?.fetchTodos()
    }
    
    func numberOfRows() -> Int {
        visibleTodos.count
    }
    
    func viewModel(at index: Int) -> TaskListViewModel? {
        guard visibleTodos.indices.contains(index) else {
            return nil
        }
        
        return makeViewModel(from: visibleTodos[index])
    }
    
    func didTapAddTask() {
        router?.navigateToTaskDetail(todo: nil)
    }
    
    func didTapTask(id: UUID) {
        guard let todo = visibleTodos.first(where: { $0.id == id }) else {
            return
        }
        
        router?.navigateToTaskDetail(todo: todo)
    }
    
    func didTapChangeStatus(id: UUID) {
        guard let index = visibleTodos.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        let updatedTodo = Todo(
            id: visibleTodos[index].id,
            title: visibleTodos[index].title,
            description: visibleTodos[index].description,
            createdAt: visibleTodos[index].createdAt,
            isCompleted: !visibleTodos[index].isCompleted
        )
        
        visibleTodos[index] = updatedTodo
        
        if let allTodosIndex = allTodos.firstIndex(where: { $0.id == id }) {
            allTodos[allTodosIndex] = updatedTodo
        }
        
        view?.changeTaskStatus(at: index)
    }
    
    func didSearch(query: String) {
        currentSearchQuery = query
        applyCurrentFilter()
    }
    
    func didTapDelete(id: UUID) {
        interactor?.deleteTodo(id: id)
    }
}

// MARK: - TaskListInteractorOutput
extension TaskListPresenter: TaskListInteractorOutput {
    func didFetchTodos(_ todos: [Todo]) {
        allTodos = todos
        applyCurrentFilter()
    }
    
    func didDeleteTodo(id: UUID) {
        guard let visibleIndex = visibleTodos.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        visibleTodos.remove(at: visibleIndex)
        allTodos.removeAll { $0.id == id }
        view?.deleteTodo(at: visibleIndex)
    }
    
    func didFailWithError(_ error: any Error) {
        view?.showError(error.localizedDescription)
    }
}

private extension TaskListPresenter {
    func makeViewModel(from todo: Todo) -> TaskListViewModel {
        TaskListViewModel(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            createdAt: dateFormatter.string(from: todo.createdAt),
            isCompleted: todo.isCompleted
        )
    }
    
    func applyCurrentFilter() {
        let trimmedQuery = currentSearchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedQuery.isEmpty {
            visibleTodos = allTodos
        } else {
            visibleTodos = allTodos.filter { todo in
                todo.title.localizedCaseInsensitiveContains(trimmedQuery) ||
                todo.description.localizedCaseInsensitiveContains(trimmedQuery)
            }
        }
        
        view?.reloadData()
    }
}
