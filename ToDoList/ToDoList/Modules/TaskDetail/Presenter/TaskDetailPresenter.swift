//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

final class TaskDetailPresenter {
    weak var view: TaskDetailViewInput?
    var interactor: TaskDetailInteractorInput?
    var router: TaskDetailRouterInput?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()
    
    private let initialTodo: Todo?
    private var currentTodo: Todo?
    
    init(todo: Todo?) {
        self.initialTodo = todo
        self.currentTodo = todo
    }
}

extension TaskDetailPresenter: TaskDetailViewOutput {
    func viewDidLoad() {
        let todo = currentTodo ?? Todo(
            id: UUID(),
            title: "",
            description: "",
            createdAt: Date(),
            isCompleted: false
        )
        
        view?.showTodo(
            TaskDetailViewModel(
                title: todo.title,
                description: todo.description,
                createdAt: dateFormatter.string(from: todo.createdAt),
                createdAtDate: todo.createdAt,
                isCompleted: todo.isCompleted
            )
        )
    }
    
    func didTapBack(
        title: String,
        description: String,
        createdAt: Date
    ) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Do not save an empty brand-new task.
        if initialTodo == nil && trimmedTitle.isEmpty && trimmedDescription.isEmpty {
            router?.close()
            return
        }
        
        guard !trimmedTitle.isEmpty else {
            view?.showError("Введите название задачи")
            return
        }
        
        let updatedTodo = Todo(
            id: currentTodo?.id ?? UUID(),
            title: trimmedTitle,
            description: trimmedDescription,
            createdAt: createdAt,
            isCompleted: currentTodo?.isCompleted ?? false
        )
        
        currentTodo = updatedTodo
        
        if initialTodo == nil {
            interactor?.saveTodo(updatedTodo)
        } else if shouldSave(updatedTodo) {
            interactor?.updateTodo(updatedTodo)
        } else {
            router?.close()
        }
    }
    
    func didTapToggleCompletion() {
        guard let todo = currentTodo else {
            currentTodo = Todo(
                id: UUID(),
                title: "",
                description: "",
                createdAt: Date(),
                isCompleted: true
            )
            view?.updateCompletion(isCompleted: true)
            return
        }
        
        let updatedTodo = Todo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            createdAt: todo.createdAt,
            isCompleted: !todo.isCompleted
        )
        
        currentTodo = updatedTodo
        view?.updateCompletion(isCompleted: updatedTodo.isCompleted)
    }
}

extension TaskDetailPresenter: TaskDetailInteractorOutput {
    func didSaveTodo() {
        router?.close()
    }
    
    func didFailWithError(_ error: any Error) {
        view?.showError(error.localizedDescription)
    }
}

private extension TaskDetailPresenter {
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
