//
//  Todo.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 31.03.26.
//

struct Todo: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
