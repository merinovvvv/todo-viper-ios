//
//  TaskListViewInput.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

protocol TaskListViewInput: AnyObject {
    func reloadData()
    func deleteTodo(at index: Int)
    func showError(_ message: String)
    func changeTaskStatus(at index: Int)
}
