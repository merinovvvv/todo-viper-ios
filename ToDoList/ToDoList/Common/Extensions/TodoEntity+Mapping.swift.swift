//
//  TodoEntity+Mapping.swift.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

extension TodoEntity {
    // MARK: - CoreData → Domain
    func toDomain() -> Todo {
        Todo(
            id: id ?? UUID(),
            title: title ?? "",
            description: todoDescription ?? "",
            createdAt: createdAt ?? Date(),
            isCompleted: isCompleted
        )
    }

    // MARK: - Domain → CoreData
    func configure(with todo: Todo) {
        self.id = todo.id
        self.title = todo.title
        self.todoDescription = todo.description
        self.createdAt = todo.createdAt
        self.isCompleted = todo.isCompleted
    }
}
