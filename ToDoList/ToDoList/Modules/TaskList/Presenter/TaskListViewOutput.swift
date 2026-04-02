//
//  TaskListViewOutput.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

protocol TaskListViewOutput: AnyObject {
    func viewDidLoad()
    func didTapAddTask()
    func didTapTask(id: UUID)
    func didTapMarkAsDone(id: UUID)
    func didPressTask(id: UUID)
    func didTapDelete(id: UUID)
    func didSearch(query: String)
}
