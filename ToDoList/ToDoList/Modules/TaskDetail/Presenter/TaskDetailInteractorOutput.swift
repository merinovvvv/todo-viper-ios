//
//  TaskDetailInteractorOutput.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

protocol TaskDetailInteractorOutput: AnyObject {
    func didSaveTodo()
    func didFailWithError(_ error: Error)
}
