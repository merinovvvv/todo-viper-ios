//
//  TaskListViewInput.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

protocol TaskListViewInput: AnyObject {
    func showTodos(_ todos: [TaskListViewModel])
    func deleteTodo(at index: Int)
    func showError(_ message: String)
    func markAsDone(at index: Int)
}
