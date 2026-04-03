//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

final class TaskDetailPresenter {
    
    // MARK: - Dependencies
    
    weak var view: TaskDetailViewInput?
    var interactor: TaskDetailInteractorInput?
    var router: TaskDetailRouterInput?
    
    // MARK: - Properties
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()
    
    private let initialTodo: Todo?
    private var todo: Todo
    
    // MARK: - Init
    
    init(todo: Todo?) {
        self.initialTodo = todo
        self.todo = todo ?? Todo(
            id: UUID(),
            title: "",
            description: "",
            createdAt: Date(),
            isCompleted: false
        )
    }
}

// MARK: - TaskDetailViewOutput
extension TaskDetailPresenter: TaskDetailViewOutput {
    func viewDidLoad() {
        view?.showTodo(makeViewModel(from: todo))
    }
    
    func didTapBack(title: String, description: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if initialTodo == nil && trimmedTitle.isEmpty && trimmedDescription.isEmpty {
            router?.close()
            return
        }
        
        guard !trimmedTitle.isEmpty else {
            view?.showError("Введите название задачи")
            return
        }
        
        let updatedTodo = Todo(
            id: todo.id,
            title: trimmedTitle,
            description: trimmedDescription,
            createdAt: todo.createdAt,
            isCompleted: todo.isCompleted
        )
        
        todo = updatedTodo
        
        if initialTodo == nil {
            interactor?.saveTodo(updatedTodo)
        } else if shouldSave(updatedTodo) {
            interactor?.updateTodo(updatedTodo)
        } else {
            router?.close()
        }
    }
    
    func didTapToggleCompletion() {
        let updatedTodo = Todo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            createdAt: todo.createdAt,
            isCompleted: !todo.isCompleted
        )
        
        todo = updatedTodo
        view?.updateCompletion(isCompleted: updatedTodo.isCompleted)
    }
}

// MARK: - TaskDetailInteractorOutput
extension TaskDetailPresenter: TaskDetailInteractorOutput {
    func didSaveTodo() {
        router?.close()
    }
    
    func didFailWithError(_ error: any Error) {
        view?.showError(error.localizedDescription)
    }
}

private extension TaskDetailPresenter {
    func makeViewModel(from todo: Todo) -> TaskDetailViewModel {
        TaskDetailViewModel(
            title: todo.title,
            description: todo.description,
            createdAt: dateFormatter.string(from: todo.createdAt),
            isCompleted: todo.isCompleted
        )
    }
    
    func shouldSave(_ todo: Todo) -> Bool {
        guard let initialTodo else {
            return true
        }
        
        return initialTodo.title != todo.title ||
        initialTodo.description != todo.description ||
        initialTodo.createdAt != todo.createdAt ||
        initialTodo.isCompleted != todo.isCompleted
    }
}
