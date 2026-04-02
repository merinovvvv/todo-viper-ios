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
    
    private var allTodos: [Todo] = []
    private var visibleTodos: [Todo] = []
        
    // MARK: - Init
    init() { }
}

// MARK: - TaskListViewOutput
extension TaskListPresenter: TaskListViewOutput {
    func viewDidLoad() {
        interactor?.fetchTodos()
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
    
    func didTapMarkAsDone(id: UUID) {
        guard let index = visibleTodos.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        let updatedTodo = Todo(
            id: visibleTodos[index].id,
            title: visibleTodos[index].title,
            description: visibleTodos[index].description,
            createdAt: visibleTodos[index].createdAt,
            isCompleted: true
        )
        
        visibleTodos[index] = updatedTodo
        
        if let allTodosIndex = allTodos.firstIndex(where: { $0.id == id }) {
            allTodos[allTodosIndex] = updatedTodo
        }
        
        view?.markAsDone(at: index)
    }
    
    func didPressTask(id: UUID) {
        // TODO: - Highlight a cell
    }
    
    func didSearch(query: String) {
        interactor?.searchTodos(query: query)
    }
    
    func didTapDelete(id: UUID) {
        interactor?.deleteTodo(id: id)
    }
}

// MARK: - TaskListInteractorOutput
extension TaskListPresenter: TaskListInteractorOutput {
    func didFetchTodos(_ todos: [Todo]) {
        visibleTodos = todos
        
        if todos.count >= allTodos.count || allTodos.isEmpty {
            allTodos = todos
        }
        
        view?.showTodos(todos.map(Self.makeViewModel))
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
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    static func makeViewModel(from todo: Todo) -> TaskListViewModel {
        TaskListViewModel(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            createdAt: dateFormatter.string(from: todo.createdAt),
            isCompleted: todo.isCompleted
        )
    }
}
