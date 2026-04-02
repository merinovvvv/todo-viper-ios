//
//  TaskListRouterInput.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

protocol TaskListRouterInput: AnyObject {
    func navigateToTaskDetail(todo: Todo?)
}
