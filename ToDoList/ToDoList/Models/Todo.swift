//
//  Todo.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 31.03.26.
//

import Foundation

struct Todo: Decodable {
    let id: UUID
    let title: String
    let description: String
    let createdAt: Date
    let isCompleted: Bool
}
