//
//  TodoDTO.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 31.03.26.
//

import Foundation

struct TodoDTO: Decodable {
    // TODO: - not used
    let id: Int
    let todo: String
    let completed: Bool
    // TODO: - not used
    let userId: Int
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
