//
//  TaskDetailInteractorInput.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

protocol TaskDetailInteractorInput: AnyObject {
    func saveTodo(_ todo: Todo)
    func updateTodo(_ todo: Todo)
}
