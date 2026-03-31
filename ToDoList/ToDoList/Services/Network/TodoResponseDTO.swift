//
//  TodoResponse.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 31.03.26.
//

struct TodoResponseDTO: Decodable {
    let todos: [TodoDTO]
    let total: Int
    let skip: Int
    let limit: Int
}
