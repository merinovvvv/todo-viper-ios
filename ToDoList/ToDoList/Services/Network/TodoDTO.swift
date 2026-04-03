//
//  TodoDTO.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 31.03.26.
//

import Foundation

struct TodoDTO: Decodable {
    let todo: String
    let completed: Bool
}

extension TodoDTO {
    func toDomain() -> Todo {
        Todo(
            id: UUID(),
            title: self.todo,
            description: "here should be some description",
            createdAt: Date(),
            isCompleted: self.completed
        )
    }
}
